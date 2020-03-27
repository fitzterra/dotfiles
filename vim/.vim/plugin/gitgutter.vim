" Some config taken from here: https://jakobgm.com/posts/vim/git-integration/
"
" Use fontawesome icons as signs
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

" The below failes with: 'BG color unknown'
" let g:gitgutter_override_sign_column_highlight = 1
" highlight SignColumn guibg=bg
" highlight SignColumn ctermbg=bg

" Update sign column every quarter second
set updatetime=250

" Toggle highlighting of chunks
nmap <Leader>ht :GitGutterLineHighlightsToggle<CR>
