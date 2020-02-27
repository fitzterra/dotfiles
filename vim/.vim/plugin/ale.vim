" Configure ale
let g:ale_linters = {
  \ 'python': ['pylint', 'mypy'] ,
  \ }

" Bind CTRL-J and CTRL-K to jump to next and previous lint errors
nmap <silent> <C-k> :ALEPrevious<cr>
nmap <silent> <C-j> :ALENext<cr>
