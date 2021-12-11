My Vim Cheat Sheet
==================

1. [External cheatsheets](#external-cheatsheets)
2. [Count number of lines in selection](#count-number-of-lines-in-selection)
3. [Open url in browser](#open-url-in-browser)
4. [Search web from vim](#search-web-from-vim)
5. [Copy word under cursor to command line](#copy-word-under-cursor-to-command-line)
6. [Visual mode cheats:](#visual-mode-cheats:)
7. [Sum numbers in highlighted block:](#sum-numbers-in-highlighted-block:)
8. [Insert full path of current file at cursor position while in insert mode](#insert-full-path-of-current-file-at-cursor-position-while-in-insert-mode)
9. [Center text within visual selection](#center-text-within-visual-selection)
10. [Delete lines matching a regex](#delete-lines-matching-a-regex)
11. [Open tab in local window split](#open-tab-in-local-window-split)


## External cheatsheets
* Open with `gx`:
* https://vimsheet.com/

## Count number of lines in selection
* `g C-g`
* https://stackoverflow.com/a/7262572

## Open url in browser
* `gx`

## Search web from vim
Installed via dotfiles plugin and set up via: `vim-browser-search.vim`  
See https://github.com/voldikss/vim-browser-search
* Select text and type `<Leader>s` to do a web search
* Type `<Leader>saw` in to search web for a word
* Type `<Leader>sa(` to search web for the text wrapped in the bracket
* Type `<Leader>sas` to search web for a sentence

## Copy word under cursor to command line
* `C-r C-w`
* See `:help c_CTRL-R` for a listing of all the other special registers

## Visual mode cheats:
Some nice things here: https://dev.to/iggredible/mastering-visual-mode-in-vim-15pl
* Reselect last visual block: `gv`
* Enter visual mode from insert mode: `C-o v` or `C-o V` or `C-o C-v`

## Sum numbers in highlighted block:
Made available via the `vissum` plugin:
* Highlight a block of text and calculate the sum of the first numbers
  found in each line by pressing <Leader>su (\su). The sum is displayed in the
  status line

## Insert full path of current file at cursor position while in insert mode
* `C-r%`
* Also see: https://vim.fandom.com/wiki/Insert_current_filename

## Center text within visual selection
Provided by `plugin/center-visual-test.vim`

This is helpful when aligning text in columns for example.
* Select the area in which to center the text.
* All text in the selection will be centered, but this is only for a
    selection on a single line, not a block
* Hit `C-^`

## Delete lines matching a regex 
See here for more: https://tech.serhatteker.com/post/2019-09/vim-delete-all-lines-with-regex/

Using the `ex` command `:g`, is very useful for acting on lines that match a pattern.
* Delete all lines that contain a regex: `:g/<regex>/d`
* Invert delete: `:g!/<regex>/d`
* Delete all empty lines (whitespace only considered empty line): `:g/^\s*$/d`

## Open tab in local window split
You have a file open in another tab and want it in the local tab as split:
* In the local window: `:sb ` then hit tab to cycle through the open buffers
    until you find the one to open in the local window.
* Using `:vert sb ` makes a vertical split

