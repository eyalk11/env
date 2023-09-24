
command! -bang -nargs=+ Plugin call <sid>PluginAdapter(<args>)

function! GetPluginName(pluginUrl)
    " Get plugin name out of a plugin spec name/url. Fairly simplistic, so
    " don't include .git at the end of your urls.
    return split(a:pluginUrl, '/')[-1]
endfunction

" Define function to check if a plugin is added to the manager.
" Accepts only the last part of the plugin name (See GetPluginName()).
" Usage: IsPluginUsed('nvim-treesitter')
if has('nvim')
    lua IsPluginUsed = function(name) return require("lazy.core.config").plugins[name] ~= nil end
endif

function! IsPluginUsed(name)
    if has('nvim')
        return has_key(s:plugs, a:name)
    else
        return has_key(g:plugs, a:name)
    endif
endfunction

" Passes plugin to lua functon that creates a lazy spec, OR extracts extra
" plug args and activates them.
function! s:PluginAdapter(...)
    let l:plugin = a:1
    let l:plugin_name = GetPluginName(l:plugin)
    let l:args = {}
    if a:0 == 2
        let l:args = a:2
    endif
    if has('nvim')
        let g:__plugin_args = l:args
        exec 'lua PlugToLazy("' . l:plugin  . '", vim.g.__plugin_args)'
        let s:plugs[l:plugin_name] = 1
    else
        " convert lazy args we want to keep when using plug
        for dep in get(l:args, 'dependencies', [])
            Plug dep
        endfor
        " Handle hook for after load
        let l:func = get(l:args, 'afterLoad', v:false)
        " If 'afterLoad' is v:true, call function based off a default name
        " convention (the plugin name, with _ replacing . and -). Otherwise
        " call the function name passed in. Only will be called for
        " lazy-loaded plugins, so don't use without an 'on' or 'for' mapping.
        " ('keys' gets ignored).
        if l:func == v:true
            exec 'au User ' . l:plugin_name . ' call ' . PluginNameToFunc(l:plugin_name) . '()'
        elseif l:func != v:false
            exec 'au User ' . l:plugin_name . ' call ' . l:func . '()'
        endif

        for event in get(l:args, 'event', [])
            " Removes unsupported events, e.g. VeryLazy.
            if !exists('##' . event)
                continue
            endif
            call s:loadPluginOnEvent(l:plugin_name, event)
            " Add empty 'on' argument to enable lazyloading.
            if !has_key(l:args, 'on')
              let l:args['on'] = []
            endif
        endfor

        call s:removeUnsupportedArgs(l:args)
        Plug l:plugin, l:args
    endif
endfunction

if !has('nvim')
    " Add support for loading Plug plugins on specific event.
    function! s:loadPluginOnEvent(name, event)
        " Plug-loads function on autocmd event.
        " Plug options should include 'on': [] to prevent load before event.
        " name: the last part of the plugin url (See GetPluginName()).
        " event: name of autocmd event
        " Example:
        " Plug 'ycm-core/YouCompleteMe', {'on': []}
        " call LoadPluginOnEvent('YouCompleteMe', 'InsertEnter')
        let l:plugLoad = 'autocmd ' . a:event . ' * call plug#load("'
        let l:plugLoadEnd = '")'
        let l:augroupName = a:name . '_' . a:event
        let l:undoAutocmd = 'autocmd! ' . l:augroupName
        exec 'augroup ' . l:augroupName
            autocmd!
            exec  l:plugLoad . a:name . l:plugLoadEnd . ' | ' . l:undoAutocmd
        exec 'augroup END'
    endfunction
endif

" To remove a Plugged repo using UnPlug 'pluginName'
function! s:deregister(name)
    " name: See GetPluginName()
    try
        if has('nvim')
            call remove(s:plugs, a:name)
            return
        else
            call remove(g:plugs, a:name)
            call remove(g:plugs_order, index(g:plugs_order, a:name))
        endif
        " strip anything after period because not legitimate variable.
        let l:varname = substitute(a:name, '\..*', '', '')
        let l:varname = substitute(l:varname, 'vim-', '', '')
        exec 'let g:loaded_' . l:varname . ' = 1'
    catch /^Vim\%((\a\+)\)\=:E716:/
        echom 'Unplug failed for ' . a:name
    endtry
endfunction
command! -nargs=1 -bar UnPlug call s:deregister(<args>)

if has('nvim')
    lua << EOF
    -- Allow making a keys table with modes for Lazy.vim in vimscript
    -- Expects a dictionary where keys are a string of modes and values are
    -- a list of keys.
    -- usage: add plugin opt:
    -- Plugin 'abc/def', {'keys': MakeLazyKeys({
    --             " \ 'n': ['[', ']'],
    --             " \ 'ov': ['i,', 'a', 'I', 'A'],
    --             " \ })}
    -- Returns a lua function for setting up a lazy keys spec. Need to return a
    -- function because can't return a mixed list/dict table in vimscript.
    MakeLazyKeys = function(args)
        return function()
            local ret = {}
            for modes, keys in pairs(args) do
                for _, key in ipairs(keys) do
                    modesT = {}
                    for i = 1, #modes do
                        modesT[i] = modes:sub(i, i)
                    end
                    table.insert(ret, { key, mode = modesT})
                end
            end
            return ret
        end
    end
EOF

    function! MakeLazyKeys(args)
        return luaeval('MakeLazyKeys(_A[1])', [a:args])
    endfunction
else
    function! MakeLazyKeys(args)
        return []
    endfunction
endif

function! PluginNameToFunc(name)
    " Convert a plugins name to default function name to use for afterLoad
    " functions.
    " Has to be a global function so lua can access it.
    return 'Plug_after_' . substitute(a:name, '[\\.-]', '_', 'g')
endfunction

if has('nvim')
let s:plugs = {}
lua << EOF
LazyPlugSpecs = {}
-- Compatibility function to convert vim-plug's Plug command to lazy.nvim spec
function PlugToLazy(plugin, opts)
    -- Build lazy plugin spec, converting any vim-plug options.
    local lazySpec = {}
    if opts then
        lazySpec = opts
        lazySpec.ft = opts["for"]
        -- lazySpec.for = nil
        lazySpec.name = opts["as"]
        lazySpec.as = nil
        lazySpec.cmd = opts["on"]
        lazySpec.on = nil
        lazySpec.version = opts["tag"]
        if opts['afterLoad'] then
            lazySpec['config'] = function()
                -- Either call the default afterLoad function...
                if opts['afterLoad'] == true then
                    vim.fn[vim.fn.PluginNameToFunc(
                        vim.fn.GetPluginName(plugin)
                    )]()
                else
                    -- ...or call the specified name.
                    vim.fn[opts['afterLoad']]()
                end
            end
        end
        if lazySpec.cmd then
            -- Ensure it is a list/table
            if type(lazySpec.cmd) == "string" then
                lazySpec.cmd = {lazySpec.cmd}
            end
            -- <plug> mappings are commands ('on') for Plug, but keys for Lazy
            for k, cmd in pairs(lazySpec.cmd) do
                if string.find(string.lower(cmd), "<plug>", 1, 6) then
                    lazySpec.keys = lazySpec.keys or {}
                    -- Convert plug mappings for all modes, not just default of 'n'
                    table.insert(lazySpec.keys, {cmd, mode={'n','v','o','l'}})
                    lazySpec.cmd[k] = nil
                end
            end
            -- Remove any empty cmd table to prevent lazyload (may be empty if
            -- used to force a lazy load in Plug)
            if not lazySpec.cmd then lazySpec.cmd = nil end
        end
    end
    lazySpec[1] = plugin
    table.insert(LazyPlugSpecs, lazySpec)
end
EOF
endif

if !has('nvim')
    function! s:removeUnsupportedArgs(args)
        " Remove args unsupported by Plug
        let l:PlugOpts = [
                    \ 'branch',
                    \ 'tag',
                    \ 'commit',
                    \ 'rtp',
                    \ 'dir',
                    \ 'as',
                    \ 'do',
                    \ 'on',
                    \ 'for',
                    \ 'frozen',
                    \ ]
        for opt in keys(a:args)
            if index(l:PlugOpts, opt) < 0  " If item not in the list.
                silent! call remove(a:args, opt)
            endif
        endfor
    endfunction
endif

function! s:installPluginManager()
    if has('nvim')
        let g:loaded_plug = 1
        lua << EOF
        local lazypath = vim.g.pluginInstallPath .. "/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
            -- bootstrap lazy.nvim
            -- stylua: ignore
            vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
        end
        vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
EOF

    else
        if has('win32') || has ('win64')
            let l:vimhome = $HOME."/vimfiles"
        else
            let l:vimhome = $HOME."/.vim"
        endif
        let l:plugin_manager_dir = expand(l:vimhome .. '/autoload')
        let l:plugin_manager_file = l:plugin_manager_dir .. '/plug.vim'
        let s:plugin_manager_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

        if !filereadable(l:plugin_manager_file)
            exec "silent !mkdir -p " . l:plugin_manager_dir
            if Executable("curl")
                let s:downloader = "curl -fLo "
            elseif Executable("wget")
                let s:downloader = "wget --no-check-certificate -O "
            else
                echoerr "You have to install curl or wget, or install plugin manager yourself!"
                echoerr "Plugin manager not installed. No plugins will be loaded."
                finish
            endif
            " Continue installing...
            echom "Installing plugin manager..."
            echo ""
            call system(printf('%s %s %s', s:downloader, l:plugin_manager_file, s:plugin_manager_url))
            if !filereadable(l:plugin_manager_file)
                echoerr "Plugin manager not installed. No plugins will be loaded."
                finish
            endif
            autocmd myPlugins VimEnter * PlugInstall
        endif

    endif
endfunction
call s:installPluginManager()
