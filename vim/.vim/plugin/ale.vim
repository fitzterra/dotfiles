" Configure ale
let g:ale_linters = {
\ 'python': ['pylint'] ,
\}

let g:ale_fixers = {
\ 'python': ['black'],
\}

" Run any fixers on save, e.g. black on python files
let g:ale_fix_on_save = 1

" Bind CTRL-J and CTRL-K to jump to next and previous lint errors
nmap <silent> <C-k> :ALEPrevious<cr>
nmap <silent> <C-j> :ALENext<cr>
" Bind F8 to run any fixer configured
nmap <F8> :ALEFix<cr>
