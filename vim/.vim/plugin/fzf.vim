" Enables fzf base extension if fzf was installed as a Debian package.
" See /usr/share/doc/fzf/README.Debian
if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
    source /usr/share/doc/fzf/examples/fzf.vim
endif

" This should be ringed in a test to see if fzf-vim is installed, but until we
" know how to do that, or have more time to learn, we do the cowboy thing and
" just set these mappings anyway
"
" Map Ctrl-p to open the fzf file selector
nnoremap <C-p> :Files<CR>
