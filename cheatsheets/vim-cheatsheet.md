My Vim Cheat Sheet
==================

External cheatsheets (open with `gx`):
* https://vimsheet.com/

* Count number of lines in selection:  
    `g C-g`
    https://stackoverflow.com/a/7262572

* Open url in browser:  
    `gx`

* Search web from vim:  
    Installed via dotfiles plugin and set up via: `vim-browser-search.vim`  
    See https://github.com/voldikss/vim-browser-search
    * Select text and type `<Leader>s` to do a web search
    * Type `<Leader>saw` in to search web for a word
    * Type `<Leader>sa(` to search web for the text wrapped in the bracket
    * Type `<Leader>sas` to search web for a sentence

* Copy word under cursor to command line:  
    `C-r C-w`
    See `:help c_CTRL-R` for a listing of all the other special registers

* Visual mode cheats:
    Some nice things here: https://dev.to/iggredible/mastering-visual-mode-in-vim-15pl

    * Reselect last visual block: `gv`
    * Enter visual mode fro insert mode: `C-o v` or `C-o V` or `C-o C-v`
