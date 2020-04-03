" Enables fzf base extension if fzf was installed as a Debian package.
" See /usr/share/doc/fzf/README.Debian
if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
    source /usr/share/doc/fzf/examples/fzf.vim
endif

