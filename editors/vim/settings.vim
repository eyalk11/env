" vim: set ft=vim:
" vim: foldmethod=marker
" vim: foldmarker={[},{]}

" Folder in which current script resides:
if v:version >= 703
    let s:scriptpath = fnameescape(expand('<sfile>:p:h'))
else
    let s:scriptpath = expand('<sfile>:p:h')
endif

" Set colorScheme variable for use in other settings
" Doesn't override preset scheme
" Background should always be set after colorscheme.
if exists('&g:colors_name')
    let colorSch = g:colors_name
endif
" Only used if colorSch not set (plugins didn't get loaded)
let g:defaultColorSch="morning"


if has("gui_running") || exists("g:gui_oni")
    let g:hasGUI=1
else
    let g:hasGUI=0
endif


set encoding=utf-8
" For highlighting, and color schemes
" Should go before ft plugin on
syntax on
filetype plugin indent on
" :h syn-sync. Complicated stuff, can't figure it out really.
autocmd myVimrc BufWinEnter,Syntax * syn sync minlines=100 | syn sync maxlines=200

" {[} Colours
let s:defaultBGGUI="light"
let s:defaultBGConsole="light"
let s:defaultColorSch="solarized"

" Set colorScheme variable for use in other settings
" Doesn't override preset scheme
" Background should always be set after colorscheme.
" Not sure if this still needs to be here if loaded before plugins...
if exists('&g:colors_name')
    let colorSch = g:colors_name
endif
" Only used if colorSch not set (plugins didn't get loaded)
let g:fallbackColorSch="morning"

if !exists ('colorSch')
    if exists("$COLOURSCHEME")
        if !exists ('g:backgroundColour')
            if $COLOURSCHEME=~"light"
                let g:backgroundColour="light"
            elseif $COLOURSCHEME=~"dar"
                let g:backgroundColour="dark"
            endif
        endif
        let colorSch=substitute($COLOURSCHEME, '_dark', '', '')
        let colorSch=substitute(colorSch, '_light', '', '')
  else
    let colorSch=s:defaultColorSch
  endif
endif
" {]} Colours

if !exists ('g:backgroundColour')
    if g:hasGUI
        let g:backgroundColour=s:defaultBGGUI
    else
        " Default fallback for console bg colour
        let g:backgroundColour=s:defaultBGConsole
    endif
endif

exec 'set background=' . g:backgroundColour


" Needs to be set before plugins use it. Set here rather than in mappings.
let mapleader = " "
let maplocalleader = " b"

"{[} GUI
if g:hasGUI
    " GUI is running or is about to start.
    " {[} ----------- Shell ----------
    " if has("win32") || has("win64")
    "     let b:hasBash=0
    "     if executable('wsl')
    "         echom "here"
    "         let b:hasBash=1
    "         set shell=wsl
    "         " Syntastic uses PATH to determine available checkers
    "         " let $PATH .= ';C:\cygwin64\bin'"
    "     elseif executable('C:\Program Files\Git\git-bash.exe')
    "         echom "now here"
    "         let b:hasBash=1
    "         set shell=\"C:\Program\ Files\Git\git-bash.exe\"
    "     elseif executable('cygwin')
    "         set shell=cygwin
    "     endif
    "     if b:hasBash
    "         set shellredir=>%s\ 2>&1
    "         set shellpipe=2>&1\|\ tee
    "         set shellcmdflag=-c
    "         set shellquote=
    "         set shellxquote=\"
    "         " set shellxquote='"'
    "         set shellslash
    "     endif
    " endif
    " " {]} ----------- Shell ----------

    " Gui used to default to idevim
    if !exists('g:ideMode')
        let g:ideMode = 0
    endif
    if g:ideMode
        set guioptions+=ciagmrLtT!
        " Larger gvim window
        set lines=999 columns=999
    else
        " Remove menus to speed up startup
        " set guioptions=M
        set guioptions-=m
        set guioptions-=tT
        set guioptions+=M
        " Larger gvim window
        set lines=40 columns=120
    endif
    set guioptions-=e
    " Enables some basic mouse input
    set mouse=a
    set mousemodel="popup_setpos"
    " Default fallback for gui bg colour
    let g:termColors="24bit"
    " if !exists('&guifont')
    if &guifont == ""
        let s:useFont = "Source\\ Code\\ Pro\\ Medium"
        if has("win32")
            exec 'set guifont=' . s:useFont . ':h11'
        elseif has("gui_macvim")
            exec 'set guifont=' . s:useFont . ':h13'
        else
            exec 'set guifont=' . s:useFont . '\ 11'
        endif
    endif
    if has("termguicolors")
        set termguicolors
    endif
    "{]}
else
    "{[} Console

    " if !has("clipboard") || $SSHSESSION
        " Without clipboard or over ssh, need mouse to select stuff sorry.
        " Allow mouse for everything except in visualmode
        " set mouse=hnic
    " endif
    " AAH, but shift/opt + click overcomes this on my terminal emulaters
    set mouse=a

    " {[} Colours
    " Use true colors
    if has("termguicolors") && exists("$COLORTERM") &&
                \ ($COLORTERM =~ "truecolor" || $COLORTERM =~ "24bit")
        set termguicolors
        " set Vim-specific sequences for RGB colors in tmux
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        let g:termColors="24bit"
        set t_Co=256
    else
        if !exists("g:termColors") && exists("$COLORTERM")
            let g:termColors=$COLORTERM
        endif
        if $TERM =~ "-256color" && !exists("g:termColors")
            let g:termColors=256
            " This wasn't being set by default under TMUX!
            set t_Co=256
        else
            " 16 should be default, or settable.
            set t_Co=16
            let g:termColors=16
        endif
    endif


    " {]}
endif
"{]}

set showcmd
" Show cursor coords
set ruler
" Highligh search as you go
set incsearch
" Ignore case in searches excepted if an uppercase letter is used
set ignorecase smartcase
if has('nvim')
    set inccommand=split
endif

" Highlight search results. Use :noh to undo
" set hlsearch
" Show line numbers
set number
if v:version >= 703
    " Line numbers are displayed relative to current line.
    set relativenumber
endif
" Hide buffer (don't ask for save) when navigating away.
set hidden
set sessionoptions-=blank
set wildmenu
" Complete longest common string, list options. Then cycle each full match
set wildmode=list:longest,full
" Allows opening files in case insensitive way.
set wildignorecase
" Mapping usable in macros/maps to trigger completion menu.
set wildcharm=<tab>
set scrolloff=5
set completeopt=longest,menu,preview
if exists("g:ideMode") && g:ideMode == 1
  " Include tags and includes in completion.
  set complete+=i
  set complete+=t
  " set completeopt+=noselect
else
  set complete-=i     " Searching includes can be slow
endif
set display=lastline
set diffopt+=vertical

if v:version >= 703
    let s:vimrcdir = fnamemodify($MYVIMRC, ":p:h")
    let s:viminfoPath=s:vimrcdir . expand("/vimfiles/viminfo")
    let s:viminfoPath=substitute(s:viminfoPath,'\\','/','g')
    exec 'set viminfo+=n' . fnameescape(s:viminfoPath)
endif

" Backupdir possibly doesn't allow // on older versions
exec 'set backupdir=' . CreateVimDir("vimfiles/backup") . expand('//')
" au BufWritePre * let &bex = '-' . strftime("%Y%b%d%X") . '.vimbackup'
set backupext=.vimbackup
exec 'set directory=' . CreateVimDir("vimfiles/swap") . expand('//')
exec 'set viewdir=' . CreateVimDir("vimfiles/views") . expand('//')
if v:version >= 703
    exec 'set undodir=' . CreateVimDir("vimfiles/undo") . expand('//')
    " Create undo file for inter-session undo
    " Extra slash means files will have unique names
    set undofile
endif
set viewoptions-=options
" Superceded by light plugi 'vim-stay'.
" save folds
" autocmd myVimrc BufWinLeave *.* mkview
" autocmd myVimrc BufWinEnter *.* silent! loadview

" Autosave
" Don't autosave if there is no buffer name.
if bufname('%') != '' && &ro != 1 && &modifiable == 1
    " Automatically save before commands like :next and :make
    set autowrite
    " Save on focus loss
    au myVimrc FocusLost * silent! :wa
    " Save leaving insert
    au myVimrc InsertLeave <buffer> :update
endif

set modeline
set modelines=5
set expandtab
set tabstop=4
let &shiftwidth=&tabstop
let &softtabstop=&shiftwidth
set smarttab
" formatoptins: See :h fo-table.
" Don't break long lines automatically.
set formatoptions +=l
" Continue comments
set formatoptions +=ro
if v:version >= 704
    " Remove comment leader on join.
    set formatoptions +=j
endif
set wrap
if v:version >= 800
    set listchars=tab:>-,trail:·,eol:¬,precedes:←,extends:→,nbsp:·
    autocmd myVimrc optionset wrap let &showbreak=''
    autocmd myVimrc optionset nowrap let &showbreak='→ '
    let &showbreak='→ '
    " put linebreak in number column? Doesn't seem to work...
    set cpoptions+=n
endif
" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]
if v:version >= 703
    " Colour the 80th column
    set colorcolumn=80
endif
" Linebreak relates to when a line wraps (ie not in a word)
set linebreak
" Vertical window splits open on right side, horizontal below
set splitright
set splitbelow
set shortmess=a
if winheight(0) < 24
    set cmdheight=1
    if winheight(0) < 18
        " Hides airline/any other status bar.
        set laststatus=0
        set showmode
    else
        set laststatus=2
    endif
else
    set cmdheight=2
endif
" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor = "latex"
if v:version >= 703
    set conceallevel=2
endif
set foldmethod=syntax
set foldminlines=6
" set foldmethod=marker
" set foldmarker={[},{]}
set foldnestmax=3
" set foldcolumn=5
set foldminlines=3
" All/some folds closed on bufopen
set foldlevelstart=1
set foldopen+=",insert"
" Use indent and manual folding
" au myVimrc BufReadPre * setlocal foldmethod=indent
" au myVimrc BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif

function! s:SetSpellFile()
  let b:spellfilename=PathExpand(expand('%:p:h') . '/custom-spellings-vim.'
        \ . &encoding . '.add')
  " Check if directory is writable. Can't check b:spellfilename directly on
  " windows because of backslashs.
  if filewritable(expand("%:p:h"))
    " Expand because of backslashes before spaces
    let &l:spellfile=expand(b:spellfilename)
  else
    setl spf=
  endif
endfunction
" set spellfile=$HOME/.vim-spell-en.utf-8.add
au myVimrc BufEnter * call s:SetSpellFile()
"Uses dictionary and source files to find matching words to complete.
"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
if has("unix") && !exists('&dictionary')
  set dictionary="/usr/dict/words"
endif

" No annoying sound on errors
set noerrorbells
" set novisualbell
" set t_vb=
" set tm=500

" Set up default file explorer plugin to be like NERDTree (for using noplugin
" mode).
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" Run on startup
" autocmd myVimrc VimEnter * :Vexplore

"highlight whitespace at the ends of lines
" autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
" autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
" highlight EOLWS ctermbg=red guibg=red

" Put buffer name in window title
function! s:SetTitle()
    if g:hasGUI
        " Exclude "Vim" for guivim (because it'll have a logo)
        let l:app = ""
    elseif has("nvim")
        let l:app = "NVim"
    else
        if exists("g:noPlugin")
            let l:app = "Vi"
        else
            let l:app = "Vim"
        endif
    endif
    if g:ideMode == 1
        let l:preTitle = "|ide" . l:app . "| "
    elseif g:liteMode == 1
        let l:preTitle = "|lite" . l:app . "| "
    else
        if l:app == ""
            let l:preTitle = ""
        else
            let l:preTitle = "|" . l:app . "| "
        endif
    endif
    let l:filename = expand("%:t")
    if l:filename == ""
        let &titlestring = 'Vim - New Buffer'
    else
        let &titlestring = l:preTitle . l:filename . ' [' . expand("%:p") . ']'
    endif
    set title
endfunction

autocmd myVimrc BufEnter,Bufwrite * call s:SetTitle()

" Autoset new buffers to scratch
autocmd myVimrc BufEnter * if &filetype == "" | setlocal ft=scratch |
            \  setlocal spell | setl ai| endif
" Automatically detect the changed filetype on write. Currently only doing
" it if the previous buftype was scratch (ie unnamed, which in default vim
" would have done this anyway)
autocmd myVimrc BufWrite * if &filetype == "scratch" | filetype detect | endif

function! s:ReadTemplate()
    filetype detect
    let l:templatePath = PathExpand(s:scriptpath . '/templates/' . &filetype . '.vim')
    if filereadable(l:templatePath)
        exec 'read ' . l:templatePath
    endif
endfunction
autocmd myVimrc BufNewFile * call s:ReadTemplate()

" {[} Set cursor based on mode.
" block cursor in normal mode, line in other.
if &term =~ "xterm\\|rxvt" || $TERM_PROGRAM =~ "mintty\\|xterm" || exists('$TMUX')
    let s:iCursor = "\<Esc>[5 q"
    let s:nCursor = "\<Esc>[1 q"
    let s:rCursor = "\<Esc>[3 q"
    let s:vCursor = "\<Esc>[2 q"
    " 1 or 0 -> blinking block
    " 2 solid block
    " 3 -> blinking underscore
    " 4 solid underscore
    " Recent versions of xterm (282 or above) also support
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar
elseif $TERM_PROGRAM =~ "iTerm" || &term =~ "konsole"
    let s:iCursor = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let s:nCursor = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
    let s:rCursor = "\<Esc>]50;CursorShape=2\x7" " Underline in replace mode
    let s:vCursor = "\<Esc>]50;CursorShape=0\x7"
endif
" if $TERMTYPE =~ "mintty"
    " Requires mintty terminal.
    " let &t_ti.="\e[1 q" " termcap mode, for terminfo
    " let &t_SI.="\<Esc>[5 q"
    " let &t_EI.="\e[1 q"
    " let &t_te.="\e[0 q" " end termcap
    " let s:iCursor = "\e[5 q"
    " let s:nCursor = "\e[1 q"
    " let s:rCursor = "\e[1 q"
    " elseif $TERMTYPE ~= "xterm"

    if exists('s:iCursor')
        " if exists('$TMUX')
        "     let s:iCursor = "\<Esc>Ptmux;\<Esc>" . s:iCursor . "\<Esc>\\"
        "     let s:nCursor = "\<Esc>Ptmux;\<Esc>" . s:nCursor . "\<Esc>\\"
        "     let s:rCursor = "\<Esc>Ptmux;\<Esc>" . s:rCursor . "\<Esc>\\"
        "     let s:vCursor = "\<Esc>Ptmux;\<Esc>" . s:vCursor . "\<Esc>\\"
        " endif
        exec 'let &t_SI = "' . s:iCursor . '""'
        exec 'let &t_EI = "' . s:nCursor . '""'
        " exec 'let &t_VS = "' . s:vCursor . '""'
        if v:version >= 800
            exec 'let &t_SR = "' . s:rCursor . '""'
        endif
        " reset cursor when vim exits
        autocmd myVimrc VimLeave * silent !echo -ne "\033]112\007"
        " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
endif
" Cursor {]}

" Auto cd to working dir of this window's file
" autocmd BufEnter * silent! lcd %:p:h
" Cursorhold autocmds fire after 1s (default 4)
set updatetime=1000

" Close quickfix or location list if it's the last remaining window in the tab
" Disable status bar too
autocmd myVimrc WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | quit | endif
autocmd myVimrc Filetype qf setlocal laststatus=0
autocmd myVimrc Filetype qf setlocal nonu
autocmd myVimrc Filetype qf setlocal norelativenumber
if v:version >= 703
    autocmd myVimrc Filetype qf setlocal colorcolumn=0
endif

au myVimrc InsertLeave * set nopaste

if $TERM =~ 'kitty'
    let &t_ut=''
endif
