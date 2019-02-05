" vim: foldmethod=marker
" vim: foldmarker={[},{]}
" Maybe later, once I want them.
" {[} ---------- Later ----------
" Plug 'https://github.com/dhruvasagar/vim-table-mode'
" Scrollwheel on mouse moves screen with cursor (more natural)
" https://github.com/reedes/vim-wheel
" Function argument movements
" Plug 'https://github.com/PeterRincker/vim-argumentative'
" Bunch of paste stuff, replacing, yankring stuff.
" https://github.com/svermeulen/vim-easyclip
" Inertial scrolling, easier to see jump movement.
" Plug "https://github.com/yuttie/comfortable-motion.vim"
" {]} ---------- Later ----------

if !exists('g:skipPipInstall') && has('nvim')
    if !has("python3")
        if executable('pip3')
            exec "!pip3 install --user --upgrade neovim"
        elseif executable('pip') && system('pip --version') =~ '3'
            exec "!pip install --upgrade --user neovim"
        " Fallback - install python 2
        elseif !has("python")
            if executable('pip2')
                exec "!pip2 install --user --upgrade neovim"
            elseif executable('pip')
                exec "!pip install --upgrade --user neovim"
            endif
        endif
    endif
endif

" {[} ---------- Misc ----------
Plug 'https://github.com/metalelf0/supertab' " Fork with a failing feature removed
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestEnhanced = 1
" List of omni completion option names in the order of precedence that they should be used if available
" let g:SuperTabContextTextOmniPrecedence = ['&completefunc', '&omnifunc']

" Lighter-weight, native completion engine. TODO sort
" Plug 'https://github.com/ajh17/VimCompletesMe'
augroup vcm
    au!
    autocmd bufenter * let b:vcm_tab_complete = 'tags'
    autocmd FileType vim let b:vcm_tab_complete = 'vim'
    autocmd FileType vim let b:vcm_tab_complete = 'omni'
augroup end

" Separate buffer lists for differetn windows
" Plug 'https://github.com/zefei/vim-wintabs'
Plug 'https://github.com/tomtom/tcomment_vim'
let g:tcomment_opleader1='<leader>c'
let g:tcomment#blank_lines=0
xmap <C-/>  :Tcomment<CR>
nmap <C-/>  :TcommentBlock<CR>
omap <C-/>  :Tcomment<CR>
Plug 'https://github.com/jacquesbh/vim-showmarks.git' " TODO fix
" Adds a bunch of unix-mapped filesystem ops from vim
Plug 'https://github.com/tpope/vim-eunuch'
Plug 'https://github.com/simnalamburt/vim-mundo'
cabbrev undo MundoToggle

" Way better search and replace, also case coersion
Plug 'https://github.com/tpope/vim-abolish'
" Improves incremental search to match everythign that it should.
Plug 'https://github.com/haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" Autoset Paste/nopaste
Plug 'https://github.com/ConradIrwin/vim-bracketed-paste'
" Allows plugin maps to use '.' to repeat
Plug 'https://github.com/tpope/vim-repeat'
" Adds indent block as text object. ii , ai or aI
Plug 'michaeljsmith/vim-indent-object'
" Adds [ ] mappins for -=+% indentation objects
Plug 'https://github.com/jeetsukumaran/vim-indentwise'
" Additional text objects for next braket, i/a comma, pairs, smarter searching.
Plug 'wellle/targets.vim'
Plug 'bkad/camelcasemotion'
call add(g:pluginSettingsToExec, "call camelcasemotion#CreateMotionMappings('<leader>m')")
Plug 'https://github.com/tpope/vim-speeddating'

" Align CSV files at commas, align Markdown tables, and more.
" Could go in prose... but maybe I'll use it more later.
Plug 'https://github.com/junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Let's give it a go then.
Plug 'https://github.com/easymotion/vim-easymotion'
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
" {]} ---------- Misc----------

" Maybe ide candidates...
" Fuzzy finder
" fzf only works in terminal, use ctrlp otherwise
if has('gui_running') && !has('terminal')
    Plug 'https://github.com/ctrlpvim/ctrlp.vim'
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_map = '<leader>f'
    let g:ctrlp_cache_dir = CreateVimDir("ctrpCache") " Purge cache with f5 in buffer
    let g:ctrlp_clear_cache_on_exit = 0
    if ideMode == 1
        let g:ctrlp_extensions = ['tag', 'buffertag', 'rtscript']
    endif
else
    " PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install
    " script
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      " Both options are optional. You don't have to install fzf in ~/.fzf
      " and you don't have to run the install script if you use fzf only in
      " Vim.
    nnoremap <leader>f :FZF<CR>
    " {[} Use proper fzf colours in gvim
    if has('gui_running')
        let g:fzf_colors =
                    \ { 'fg':      ['fg', 'Normal'],
                    \ 'bg':      ['bg', 'Normal'],
                    \ 'hl':      ['fg', 'Comment'],
                    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
                    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
                    \ 'hl+':     ['fg', 'Statement'],
                    \ 'info':    ['fg', 'PreProc'],
                    \ 'border':  ['fg', 'Ignore'],
                    \ 'prompt':  ['fg', 'Conditional'],
                    \ 'pointer': ['fg', 'Exception'],
                    \ 'marker':  ['fg', 'Keyword'],
                    \ 'spinner': ['fg', 'Label'],
                    \ 'header':  ['fg', 'Comment'] }
    endif
    " {]}
endif
" Run shell commands async (uses python)
Plug 'https://github.com/joonty/vim-do'
Plug 'https://github.com/thinca/vim-quickrun'
" Select code to execute.
Plug 'https://github.com/JarrodCTaylor/vim-shell-executor'
" Make is run async (view quickfix with :COpen)
Plug 'https://github.com/tpope/vim-dispatch'

" {[} ---------- Git ----------
if executable("git")
    " augroup myGit
    "     au!
    " augroup end
    " :Magit to check all sorts of git stuff. Looks really cool. Capitals for 
    " commands, eg [S]tage-toggle, [CC]ommit.
    Plug 'jreybert/vimagit'
    " Git wrapper
    Plug 'https://github.com/tpope/vim-fugitive'
    " nnoremap <leader>gs :Gstatus<CR> cabbrev gs Gstatus
    cabbrev gs Gstatus
    cabbrev gw Gwrite
    cabbrev gc Gwrite <bar> Gcommit
    cabbrev gco Gcommit
    cabbrev gup Gcommit --amend --no-edit
    cabbrev gdf Gdiff
    " Async fugitive
    if g:hasAsyncrun
        call add(g:pluginSettingsToExec, "command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
                    \if exists(':Make') == 2
                    \noautocmd Make
                    \else
                    \silent noautocmd make!
                    \redraw!
                    \return 'call fugitive#cwindow()'
                    \endif")
    endif
    " github wrapper
    Plug 'https://github.com/tpope/vim-rhubarb'
    Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'

    " VCS changes shown in sign column.
    Plug 'https://github.com/mhinz/vim-signify'
    " Add VCS systems to this when needed. More will slow buffer loading.
    let g:signify_vcs_list = [ 'git' ]
    " Async, so shouldn't be too bad. Ignored if not async.
    " let g:signify_realtime = 1
    " Causes a write on cursorhold. PITA, so let's replace it.
    " call add(g:pluginSettingsToExec, "autocmd! signify CursorHold,CursorHoldI")
    if has('timers')
        augroup mysignify
            au!
            " This seems to be causing an annoying error :/
            " autocmd CursorHold,CursorHoldI,BufEnter,FocusGained call silent! sy#start()
            " autocmd WinEnter call silent! sy#start()
            autocmd User Fugitive silent! SignifyRefresh
        augroup end
    endif
    " let g:signify_update_on_focusgained = 1
    let g:signify_sign_change = '~'

    " Plug 'airblade/vim-gitgutter'
    " " Allows hlcolumn bg to match coloursch
    " call add(g:customHLGroups, "clear SignColumn")
    " " gitgutter needs grep to not output escap sequences.
    " " let g:gitgutter_grep = ''
    " let g:gitgutter_grep = 'grep --color=never'
    " let g:gitgutter_override_sign_column_highlight = 0
    " let g:gitgutter_escape_grep = 1
    " " Disable automatic update
    " autocmd! gitgutter CursorHold,CursorHoldI
    " " " Wait 2000 ms after typing finishes before updating (vim default 4000)
    " " set updatetime=2000
    " augroup ggutter
    "     au!
    "     au BufWritePost * :GitGutter
    " augroup end
    " " Speed issues
    " " plugin only runs on BufRead, BufWritePost and FileChangedShellPost, i.e. when you open or save a file.
    " let g:gitgutter_realtime = 0
    " let g:gitgutter_eager = 0

    Plug 'https://github.com/christoomey/vim-conflicted'
    set stl+=%{ConflictedVersion()}
endif
" {]} ---------- Git----------

" {[} ---------- Prose ----------
" Plug 'https://github.com/plasticboy/vim-markdown'
" Better prose spellchecking
exec "Plug 'https://github.com/reedes/vim-lexical', { 'for': " . g:proseFileTypes . " }"
let g:lexical#spell_key = '<leader>ls'
let g:lexical#thesaurus_key = '<leader>lt'
let g:lexical#dictionary_key = '<leader>ld'
" Neccesary for next plugin
exec "Plug 'https://github.com/kana/vim-textobj-user', { 'for': " . g:proseFileTypes . " }"
" Expands what a sentence/word is for prose.
exec "Plug 'https://github.com/reedes/vim-textobj-sentence', { 'for': " . g:proseFileTypes . " }" 
" vimL word usage highlighter
exec "Plug 'https://github.com/reedes/vim-wordy', { 'for': " . g:proseFileTypes . " }"
exec "Plug 'bluedrink9/vim-highlight-gender', { 'for': " . g:proseFileTypes . " }"
exec "Plug 'https://github.com/vim-scripts/LanguageTool', { 'for': " . g:proseFileTypes . " }"
" An alternative to langtool:https://github.com/rhysd/vim-grammarous 
exec "Plug 'https://github.com/panozzaj/vim-autocorrect', { 'for': " . g:proseFileTypes . " }"
" Limelight Looks really nice, esp for prose. Highlight slightly current paraghraph.
exec "Plug 'junegunn/limelight.vim', { 'for': " . g:proseFileTypes . " }"

function! SetProseOptions()
    " Add dictionary completion. Requires setting 'dictionary' option.
    setlocal complete+=k
    call add (g:pluginSettingsToExec, "call AutoCorrect()")
    call add (g:pluginSettingsToExec, "call textobj#sentence#init()")
    " Default spelling lang is En, I want en_nz.
    if &spelllang == "en"
        " Custom lang not set.
        setl spell spl=en_nz
    endif
    call add (g:pluginSettingsToExec, "call pencil#init()")
    setl ai
endfunction

" if &filetype == "" || &filetype == "scratch"
"     call pencil#init()
" endif
" Bullets.vim
let g:bullets_enabled_file_types = [
            \ 'markdown',
            \ 'text',
            \ 'gitcommit',
            \ 'scratch'
            \]
" {]} ---------- Prose----------

" {[} ---------- NerdTree ----------
Plug 'https://github.com/scrooloose/nerdtree.git'
" Change these if you feel the desire...
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "?",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ 'Ignored'   : '☒',
            \ "Unknown"   : "?"
            \}
" Open nerdtree in currently focussed window, rather than sidebar.
let NERDTreeHijackNetrw=1
" Delete buffer if delete file in NT.
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden=1
augroup NT
    autocmd!
    " Open nerdtree on directory edit (startup)
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    autocmd BufRead * if isdirectory(@%) | exec 'NERDTree' | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" {]} ---------- NerdTree ----------

" {[} ---------- Airline ----------
Plug 'https://github.com/vim-airline/vim-airline-themes'
" exec "Plug \'https://github.com/vim-airline/vim-airline-themes\', {\'rtp\' : \'autoload/airline/themes/". colorSch . ".vim\'}"
Plug 'https://github.com/vim-airline/vim-airline'

if g:hasAsyncrun
    " Async errors appear in airline.
    let g:asyncrun_status = ''
    call add (g:pluginSettingsToExec, "let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])")
endif

function! s:AirlineColorVarUpdate()
    let s:restoreCS = g:colorSch
    if g:colorSch == "default"
        let g:colorSch = &background
    endif
    let g:airline_theme=g:colorSch
    exec 'let g:airline_' . g:colorSch . '_bg="' . &background . '"'
    let g:colorSch=s:restoreCS
endfunction

call s:AirlineColorVarUpdate()
let g:airline#extensions#wordcount#enabled = 1
let g:airline_solarized_normal_green = 1
let g:airline_solarized_dark_inactive_border = 1
" exec 'let g:airline_base16_' . colorSch . '= 0'
" {[} ---------- Nerd/pl fonts and symbols ----------
" let g:airline_symbols_ascii=1
" If ssh, don't assume font avail? Or should we...?
if g:remoteSession
    let g:airline_powerline_fonts=0
    let g:webdevicons_enable=0
endif
" Env variables, can be set by ssh client on login if it supports PL.
if $USENF==1
    let g:airline_powerline_fonts=1
    let g:webdevicons_enable=1
elseif $USEPF==1
    let g:airline_powerline_fonts=1
elseif $USEPF==0
    let g:airline_powerline_fonts=0
elseif $USENF==0
    let g:airline_powerline_fonts=0
    let g:webdevicons_enable=0
endif
" Check if either of these have been specifically disabled or enabled.
if !exists('g:airline_powerline_fonts') || !exists('g:webdevicons_enable')
    " Automatically check for powerline compatible font installed locally
    " (unix) or to system (windows)
    " If we are (probably) using a powerline compatible font, set it so.
    " If a nerd font is found, assume powerline-compat, as well as devicons.
    "

    if has("gui_running")
        let s:guiUsesNerdFont = 
                    \ &guifont =~ "Nerd" ||
                    \ &guifont =~ "Sauce"

        let s:guiUsesPLFont = s:guiUsesNerdFont || 
                    \ &guifont =~ "Powerline" ||
                    \ &guifont =~ "Source\\ Code\\ Pro"

        let s:usePLFont = s:guiUsesPLFont
        let s:useNerdFont = s:guiUsesNerdFont
    else

        if has("unix")
            let s:uname = system("uname")
            if s:uname =~ "Darwin"
                " OSX
                exec "let s:fontdir = expand('" . $HOME . "/Library/Fonts')"
            else
                " Linux
                exec "let s:fontdir = expand('" . $HOME . "/.fonts')"
            endif
        else
            " Windows
            exec "let s:fontdir = expand('" . $windir . "/Fonts')"
        endif

        let s:nerdFontNames = [
                    \ "Sauce Code Pro Nerd Font Complete Mono Windows Compatible.ttf",
                    \ "Sauce Code Pro Nerd Font Complete Windows Compatible.ttf",
                    \ "Sauce Code Pro Nerd Font Complete Mono.ttf",
                    \ "Sauce Code Pro Medium Nerd Font Complete.ttf",
                    \ "Sauce Code Pro Nerd Font Complete.ttf" ]
        let s:nerdFontIsInstalled = []
        let s:PLFontNames = [
                    \ "SourceCodePro-Regular.ttf",
                    \ "SourceCodePro-Regular.otf"]
        let s:PLFontIsInstalled = []

        let s:nerdFontExists = 0
        let s:PLFontExists = 0
        let i = 0
        while i < len(s:nerdFontNames)
            exec "call add(s:nerdFontIsInstalled, 
                        \ filereadable( expand('" . s:fontdir . "/" . s:nerdFontNames[i] . "')))"
            exec "let s:nerdFontExists = " . s:nerdFontExists . " || " . s:nerdFontIsInstalled[i]
            exec "let s:PLFontExists = " . s:nerdFontExists . " || " . s:nerdFontIsInstalled[i]
            let i += 1
        endwhile

        let i = 0
        if !s:nerdFontExists
            while i < len(s:PLFontNames)
                exec "call add(s:PLFontIsInstalled, 
                            \ filereadable( expand('" . s:fontdir . "/" . s:PLFontNames[i] . "')))"
                exec "let s:PLFontExists = " . s:PLFontExists . " || " . s:PLFontIsInstalled[i]
                let i += 1
            endwhile
        endif

        let s:usePLFont = s:PLFontExists
        let s:useNerdFont = s:nerdFontExists
    endif

    if !exists('g:airline_powerline_fonts')
        if s:usePLFont
            let g:airline_powerline_fonts = 1
        else
            let g:airline_powerline_fonts = 0
        endif
    endif

    if s:useNerdFont == 0
        if !exists('g:webdevicons_enable')
            " disable devicons and dependents.
            let g:NERDTreeDisableFileExtensionHighlight = 1
            let g:NERDTreeDisableExactMatchHighlight = 1
            let g:NERDTreeDisablePatternMatchHighlight = 1
            let g:webdevicons_enable = 0
        endif
    endif
endif

" if exists('g:airline_powerline_fonts') && g:airline_powerline_fonts == 0
" Should always exist, because if it doesn't it's created above.
if g:airline_powerline_fonts == 0 
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    " unicode symbols
    let g:airline#extensions#tabline#left_sep = '▶'
    let g:airline#extensions#tabline#right_sep = '◀'
    let g:airline#extensions#tabline#left_sep_alt = '|'
    let g:airline#extensions#tabline#right_sep_alt = '|'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '☰'
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.columnnr = '∥'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'PASTE'
    let g:airline_symbols.whitespace = '☲'
    " airline symbols
    let g:airline_symbols.readonly = ''

    " Skip gap between col symbol and number (custom section)
    call add (g:pluginSettingsToExec,
                \ "call airline#parts#define_raw('linenr', g:airline_symbols.linenr . ' %l')")
    call add (g:pluginSettingsToExec,
                \ "call airline#parts#define_raw('columnnr', g:airline_symbols.columnnr . '%c')")
    call add (g:pluginSettingsToExec, "let g:airline_section_z = airline#section#create([
                \ 'linenr', 'maxlinenr',' ', 'columnnr'])")
else
    " Using predefined symbols
    " Skip gap between col symbol and number (custom section)
    call add (g:pluginSettingsToExec, "call airline#parts#define_raw('linenr', g:airline_symbols.linenr . '%l')")
    call add (g:pluginSettingsToExec, "let g:airline_symbols.columnnr = '∥'")
    if !exists('g:airline_symbols.columnnr')
        let g:airline_symbols = {}
    endif
    call add (g:pluginSettingsToExec,
                \ "call airline#parts#define_raw('columnnr', g:airline_symbols.columnnr . '%c')")
    call add (g:pluginSettingsToExec, "let g:airline_section_z = airline#section#create([
                \ 'linenr', 'maxlinenr',' ', 'columnnr'])")
endif

" {]} ---------- Nerd/pl fonts----------

let g:airline#extensions#syntastic#stl_format_err="%E{Err: #%e L%fe}"
let g:airline#extensions#syntastic#stl_format_warn='%W{Warn: #%w L%fw}'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 0
" let g:airline#extensions#tabline#buffer_min_count = 0
" let g:airline#extensions#tabline#tab_min_count = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffers_label = 'B'
let g:airline#extensions#whitespace#mixed_indent_algo = 1
" Alt sep gives b<c>b instead of b>c>b
let g:airline#extensions#tabline#alt_sep = 1
let g:airline#extensions#tabline# = 1
" let g:airline#extensions#tabline#show_tabs = 0
call add (g:pluginSettingsToExec, "let g:airline_section_tabline = airline#section#create(['%{getcwd()}'])")

let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#whitespace#checks = []
" Disable mode shown in cmdline
set noshowmode
"  reduce delay on insert leaave?
set ttimeoutlen=50

if winheight(0) < 20
    " Hides airline/any other status bar.
    let g:loaded_airline = 1
endif
augroup myAirline
    autocmd!
    autocmd colorscheme * call s:AirlineColorVarUpdate()
    if v:version >= 800
        autocmd optionset background call s:AirlineColorVarUpdate()
    endif
augroup end
" augroup myAirline
"     autocmd!
"     autocmd colorscheme let g:airline_theme=colorSch | AirlineRefresh
"     autocmd optionset background exec 'let g:airline_' . colorSch . '_bg="' . &background . '"' | AirlineRefresh
" augroup end

" {]} ---------- airline ----------

