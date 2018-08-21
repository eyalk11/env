" vim: foldmethod=marker
" vim: foldmarker={[},{]}
if g:liteMode
" Superlight airline (no plugins)
    " Plug 'https://github.com/itchyny/lightline.vim'
    " {[} Replace Tcomment with commentary
    " Replaced in favour of slightly heavier version tcomment in main
    " plugins. See https://github.com/wincent/wincent/commit/913e79724456976549244893e9025aa6fcf3cc1c
    Plug 'https://github.com/tpope/vim-commentary'
    " Normal commentary maps (eg gcc) only happen if gc isn't mapped or
    " Commentary isn't already re-mapped.
    xmap <leader>c  <Plug>Commentary
    nmap <leader>c  <Plug>Commentary
    omap <leader>c  <Plug>Commentary
    nmap <leader>cc <Plug>CommentaryLine
    nmap l<leader>c <Plug>ChangeCommentary
    nmap <leader>cu <Plug>Commentary<Plug>Commentary
    xmap <C-/>  <Plug>Commentary
    nmap <C-/>  <Plug>Commentary
    omap <C-/>  <Plug>Commentary
    " {]} Replace Tcomment with commentary

    " Lighter alt to airline for putting buffers in tabline.
    Plug 'https://github.com/ap/vim-buftabline'
    " Only show buffer line if there are > 2 buffers open.
    let g:buftabline_show=1
    let g:buftabline_numbers=2
endif

" {[} ---------- Colourschemes ----------
" {[} ---------- Solarized ----------
if v:version >= 704 && &termguicolors
    Plug 'https://github.com/lifepillar/vim-solarized8'
    let g:solarized_old_cursor_style=1
    if g:termColors == 16
        let g:solarized_use16 = 1
    endif
    call add (g:pluginSettingsToExec, "colorscheme solarized8_high")
else
    Plug 'https://github.com/altercation/vim-colors-solarized.git'
    " Settings doesn't recommend this...
    let g:solarized_contrast = "high"
    let g:solarized_termtrans = 0 " 1 displays default term bg instead.
    let g:solarized_menu = 0
    if g:termColors == 16
        " According to solarized help, 16 is default anyway, so shouldn't need
        " these set if not using 256.
        " let g:solarized_base16 = 1
        let g:solarized_termcolors=16
    elseif g:termColors == 256
        let g:solarized_termcolors=256
    endif
    call add (g:pluginSettingsToExec, "colorscheme " . colorSch)
endif
" {]}

" call add (g:pluginSettingsToExec, "colorscheme " . colorSch)
call add (g:customHLGroups, "MatchParen cterm=bold,underline ctermbg=lightgray")
call add (g:customHLGroups, "MatchParen gui=bold,underline guibg=gray90")

" {]} ---------- Colourschemes ----------

" {[}--- Misc ---
" Bunch of neat mappings, it's a tpope. Esp [n and ]n, for SCM conflict marks.
" And [<space> for addign newlines.
Plug 'https://github.com/tpope/vim-unimpaired'
Plug 'https://github.com/chrisbra/csv.vim'
let g:csv_autocmd_arrange	   = 1
let g:csv_autocmd_arrange_size = 1024*1024
" let g:csv_highlight_column = 'y' " Current cursor's column.
" hi CSVColumnEven term=bold ctermbg=Gray guibg=LightGray
call add (g:customHLGroups, "CSVColumnEven guibg=gray90 ctermbg=lightgray")
call add (g:pluginSettingsToExec, "highlight clear CSVColumnOdd")
Plug 'nathanaelkane/vim-indent-guides'
" For switching between header and alt files
Plug 'vim-scripts/a.vim'
" Bsgrep for searching in all open buffers. Also Bsreplace, Bstoc.
Plug 'https://github.com/jeetsukumaran/vim-buffersaurus'
cabbrev bfind Bsgrep
let g:buffersaurus_autodismiss_on_select=0
Plug 'https://github.com/ntpeters/vim-better-whitespace'
let g:show_spaces_that_precede_tabs=1
let g:better_whitespace_skip_empty_lines=1
let g:better_whitespace_operator='_s'
call add (g:customHLGroups, "ExtraWhitespace ctermbg=Gray guibg=LightGray")
" cx to select an object, then cx again to swap it with first thing.
Plug 'https://github.com/tommcdo/vim-exchange'
" if v:version >= 800 || has("patch-7.4.1829")
if has("timers")
    " Commands sent to shell with AsyncRun appear in qf window.
    " use AsyncRun! to prevent autoscroll.
    Plug 'https://github.com/skywind3000/asyncrun.vim'
    let g:hasAsyncrun = 1
    " Open quickfix window at height 8 on running
    let g:asyncrun_open = 8
    " cmap !! AsyncRun
    " cmap ! AsyncRun
    cabbrev ! AsyncRun
    let g:asyncrun_auto = "make"
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
    " Set qf statusbar to status of asyncrun
    let g:asyncrun_status = "stopped"
    augroup qfas
        au!
        autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)
        autocmd BufWinEnter quickfix setlocal 
                    \ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
    augroup END
endif
" {]} Misc

" {[} --- TMUX ---
Plug 'https://github.com/tmux-plugins/vim-tmux'
Plug 'https://github.com/christoomey/vim-tmux-navigator'
Plug 'https://github.com/benmills/vimux'
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" {]} TMUX

" Close buffers without changing window
Plug 'https://github.com/moll/vim-bbye'
cabbrev bd Bdelete
Plug 'ericbn/vim-relativize'
if v:version >= 702
    " Highlight f and t chars to get where you want.
    " TODO monitor progress of this branch. May be updated soon.
    " Plug 'unblevable/quick-scope'
    Plug 'https://github.com/bradford-smith94/quick-scope'
    " Trigger a highlight in the appropriate direction when pressing these keys:
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
endif

Plug 'xolox/vim-misc'
" Map os commands (eg maximise), and open windows commands without shell
" popup.
Plug 'https://github.com/xolox/vim-shell'
if v:version >= 704
    Plug 'https://github.com/xolox/vim-session'
    let g:session_persist_globals = ['&spelllang', '&autoread', '&spell']
    let g:session_persist_colors = 0
    let g:session_persist_font = 0
    let g:session_default_to_last = 'yes'
    let g:session_autosave_periodic = 10
    let g:session_autosave = 'yes'
    let g:session_autoload = 'yes'
    let g:session_directory = CreateVimDir("vimfiles/sessions/")
    cabbrev cs CloseSession
    cabbrev os OpenSession
    cabbrev ss SaveSession
endif

Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/maxbrunsfeld/vim-yankstack.git'
let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
call add(g:pluginSettingsToExec, "call yankstack#setup()")
if v:version >= 704
    Plug 'https://github.com/jlanzarotta/bufexplorer.git'
endif
Plug 'https://github.com/junegunn/rainbow_parentheses.vim'
" Distraction-free vim.
Plug 'https://github.com/junegunn/goyo.vim'



" {[} ---------- Prose ----------
Plug 'https://github.com/tpope/vim-markdown'
Plug 'https://github.com/lervag/vimtex'
" Ensure clean doesn't immediately get overridden...
nnoremap \lc :VimtexStop<cr>:VimtexClean<cr>
" call add(g:pluginSettingsToExec, "let g:vimtex_compiler_latexmk.build_dir = 'latexbuild'")
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : 'latexbuild',
    \ 'options' : [
    \ ],
    \}
" Plug 'https://github.com/vim-latex/vim-latex'
" let g:Tex_DefaultTargetFormat="pdf"
if has('win32')
    let g:vimtex_view_general_viewer = 'sumatrapdf'
    let g:vimtex_view_general_options
                \ = '-reuse-instance -forward-search @tex @line @pdf'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance --unique'
    let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
endif
Plug 'https://github.com/reedes/vim-pencil'
Plug 'https://github.com/dkarter/bullets.vim'
let g:pencil#wrapModeDefault = 'soft'
let g:pencil#autoformat_blacklist = [
            \ 'markdownCode',
            \ 'markdownUrl',
            \ 'markdownIdDeclaration',
            \ 'markdownLinkDelimiter',
            \ 'markdownHighlight[A-Za-z0-9]+',
            \ 'mkdCode',
            \ 'mkdIndentCode',
            \ 'markdownFencedCodeBlock',
            \ 'markdownInlineCode',
            \ 'mmdTable[A-Za-z0-9]*',
            \ 'txtCode',
            \ 'texMath',
            \ ]
" {]} ---------- Prose----------
