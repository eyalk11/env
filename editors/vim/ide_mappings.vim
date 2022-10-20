" {[} ------ IDE Mappings ------
" gh - get hint on whatever's under the cursor
" Use g[] for get [something].
" Use <leader>i for ide bits.
" Use <leader>e for errors/linting/fixing.
let g:IDE_mappings = {
            \ 'FuzzyBuffers' : '<leader>,',
            \ 'FuzzyCommands' : '<leader>;',
            \ 'FuzzyOpenFile' : '<leader><leader>',
            \ 'FuzzyOldFiles' : '<leader>fr',
            \ 'FuzzySearchBuffer' : '<leader>/',
            \ 'FuzzySearchBuffers' : '<leader>f',
            \ 'FuzzySearchFiles' : '<leader>F',
            \ 'FuzzyTags' : '<leader>it',
            \ 'FuzzyLspTags' : '<leader>iT',
            \ 'VCSNextHunk' : '<leader>g]',
            \ 'VCSPreviousHunk' : '<leader>g[',
            \ 'REPLSend' : '<leader>s',
            \ 'REPLSendLine' : '<leader>ss',
            \ 'REPLSendFile' : '<leader><s-S>',
            \ 'REPLSendAndInsert' : '<leader>s+',
            \ 'REPLClear' : '<leader>sc',
            \ 'REPLCancel' : '<leader>s<c-c>',
            \ 'REPLClose' : '<leader>sx',
            \ 'lintBuffer' : '<leader>il',
            \ 'make' : 'm<cr>',
            \ 'make2' : '<leader>im',
            \ 'make3' : 'm<space>',
            \ 'allActions' : '<leader>ia',
            \ 'allCommands' : '<leader>ic',
            \ 'codeAction' : '<leader>ia',
            \ 'codeActionSelected' : '<leader>iaa',
            \ 'codelensAction' : '<leader>ial',
            \ 'complete' : '<c-space>',
            \ 'signature' : '<leader>is',
            \ 'definition' : 'gd',
            \ 'definition2' : '<leader>id',
            \ 'type_definition' : 'gD',
            \ 'type_definition2' : '<leader>iD',
            \ 'documentation' : 'K',
            \ 'documentation2' : 'gh',
            \ 'documentation3' : '<leader>ih',
            \ 'fix' : '<leader>ef',
            \ 'implementation' : '<leader>ii',
            \ 'implementation2' : 'gi',
            \ 'listErrs' : '<leader>el',
            \ 'diagnostic' : '<leader>i?',
            \ 'diagnostic_next' : ']e',
            \ 'diagnostic_prev' : '[e',
            \ 'refactor' : '<leader>irr',
            \ 'references' : 'gr',
            \ 'references2' : '<leader>if',
            \ 'reformat' : '<leader>irf',
            \ 'rename' : '<leader>irn',
            \ 'renameModule' : '<leader>irm',
            \ 'snippet_expand' : '<c-e>',
            \ 'snippet_prev' : '<c-b>',
            \ 'snippet_next' : '<c-f>',
            \ 'debug_file' : '<leader>dd',
            \ 'debug_start' : '<leader>dD',
            \ 'debug_restart' : '<leader>dR',
            \ 'debug_reset' : '<leader>dC',
            \ 'debug_continue' : '<leader>dc',
            \ 'debug_step_over' : '<leader>.',
            \ 'debug_step_into' : '<leader>>',
            \ 'debug_step_out' : '<leader>^',
            \ 'debug_step_back' : '<leader><',
            \ 'debug_run_to_here' : '<leader>dh',
            \ 'debug_show_output' : '<leader>do',
            \ 'debug_hover' : '<leader>d?',
            \ 'debug_inspect' : '<leader>di',
            \ 'debug_frame_up' : '<leader>dk',
            \ 'debug_frame_down' : '<leader>dj',
            \ 'set_breakpoint' : '<leader>b',
            \ 'set_breakpoint_conditional' : '<leader>dbc',
            \ 'add_breakpoint_functional' : '<leader>dbf',
            \ 'breakpoint_list' : '<leader>dbl',
            \}
" {]} ------ IDE Mappings ------

" To consider:
" workspace open file?
