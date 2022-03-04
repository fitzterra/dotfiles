" Enables fzf base extension if fzf was installed as a Debian package.
if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
    " See /usr/share/doc/fzf/README.Debian
    source /usr/share/doc/fzf/examples/fzf.vim
elseif filereadable("/opt/homebrew/opt/fzf/plugin/fzf.vim")
    " For MacOS with fzf installed via homebrew, the default fzf+vim
    "instructions for just adding the fzf path to the vim runtime path does not
    "seem to work. Sourcing the file like this works fine.
    source /opt/homebrew/opt/fzf/plugin/fzf.vim
endif

" NOTE: This should be ringed in a test to see if fzf-vim is installed, but
" until we know how to do that, or have more time to learn, we do the cowboy
" thing and just set these mappings anyway
"
" Map Ctrl-p to open the fzf file selector
nnoremap <C-p> :Files<CR>
