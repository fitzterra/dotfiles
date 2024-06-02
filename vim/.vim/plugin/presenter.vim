" Set up vim as presenter using GoYo and markdown slides
" See: https://nickjanetakis.com/blog/giving-a-text-based-slide-presentation-in-vim-without-plugins#demo-video

autocmd BufNewFile,BufRead *.vpm call SetVimPresentationMode()
function SetVimPresentationMode()
  nnoremap <buffer> <Right> :n<CR>
  nnoremap <buffer> <Left> :N<CR>

  if !exists('#goyo')
    Goyo
    let &fillchars ..= ',eob: '
  endif
endfunction
