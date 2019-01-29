" vim: foldmethod=marker
" vim: foldmarker={[},{]}
"
if !exists ('colorSch')
    let colorSch="solarized"
endif

augroup colourschemes
    autocmd!
    autocmd colorscheme * let colorSch = get(g:, 'colors_name', 'default')
augroup end

Plug 'https://github.com/vim-scripts/oceandeep'
Plug 'https://github.com/morhetz/gruvbox'
Plug 'https://github.com/jnurmine/Zenburn'
Plug 'https://github.com/tomasr/molokai'
Plug 'dracula/vim', { 'as': 'dracula' }
" {[} ---------- Base16 ----------
" If using a Base16 terminal theme designed to keep the 16 ANSI colors intact (a "256" variation) and have sucessfully modified your 256 colorspace with base16-shell you'll need to add the following to your ~/.vimrc before the colorsheme declaration.
" let base16colorspace=256  " Access colors present in 256 colorspace
Plug 'https://github.com/chriskempson/base16-vim'
" {]} ---------- Base16 ----------

" {[} ---------- Solarized ----------
if $ISTERMUX
    " Replaces solarized for termux solarized theme
    https://github.com/Breta01/Termux-Themes
else
    " Altercation's version doesn't set gui colors in terminal (no termguicolours)
    Plug 'nisavid/vim-colors-solarized'
endif
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
" {]}

" call add (g:pluginSettingsToExec, "colorscheme " . colorSch)
call add (g:customHLGroups, "MatchParen cterm=bold,underline ctermbg=lightgray")
call add (g:customHLGroups, "MatchParen gui=bold,underline guibg=gray90")
" call add (g:customHLGroups, "link MatchParen CursorColumn")
call add (g:customHLGroups, "clear SignColumn")
call add (g:customHLGroups, "link SignColumn LineNr")
