" Config for vim airline

" We want to use the nice triangles as arrows in the status line.
" For this to work, make sure you have the powerline fonts package installed:
" sudo apt-get install fonts-powerline
let g:airline_powerline_fonts = 1
let g:airline_symbols_ascii = 0

" Setting the space as below is needed to fix the weird airline symbols in
" gvim. It looks very nice without it in terminal vim though.
" See here: https://github.com/vim-airline/vim-airline/issues/256#issuecomment-57642828
" We also need to have airline_symbols defined first
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\u3000"
