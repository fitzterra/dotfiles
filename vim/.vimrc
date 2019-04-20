"
" Local Vim config
"

" We want syntax highligting on
syntax on

" Set a color scheme
colorscheme desert

" Some more things we want...
set nocompatible        " Required by vim-wiki, nd should be set fairly early on
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set incsearch           " Incremental search
set autowrite           " Automatically save before commands like :next and :make
set nowrap				" Do not wrap long lines
set tabstop=4			" Tabs in existing files are 4 columns wide
set expandtab			" Inserting a tab will create spaces. Use Ctrl-V Tab for real tab
set softtabstop=4		" Number of spaces to use for a tab with expandtab set
set shiftwidth=4		" Autoindentation is 4 columns
set smarttab			" Switch on smarttab
set autoindent			" Copy indents from current line when starting a new line
set smartindent			" Set smart indenting on
set modeline			" Allow support for modelines in files
set hlsearch			" Highlight search results
set conceallevel=2      " Specifically in markdown, conceals the markup around text

" Make folding available but leave it manual unless overridden by a syntax file
set foldmethod=manual
set foldcolumn=3

" In GUI mode, the toolbar wastes more space than being useful. Remove it
set guioptions-=T

" Make Ctrl-S save command in both normal mode and insert mode
map <C-S> :w<CR>
imap <C-S> <Esc>:w<CR>
" Make Ctrl-Tab and Ctrl-Shift-Tab cycle through open tabs in both normal mode
" and insert mode
map <C-Tab> :tabnext<CR>
imap <C-Tab> <Esc>:tabnext<CR>
map <C-S-Tab> :tabprevious<CR>
imap <C-S-Tab> <Esc>:tabprevious<CR>
" Ctrl-N opens a new tab with the file editor in the current dir in both
" normal and insert modes
" NOTE: We are slowly changing this to use Ctrl-T instead of Ctrl-N to be
" more compliant with the latest tabbed windows keys.
map <C-N> :tabnew .<CR>
imap <C-N> <Esc>:tabnew .<CR>
map <C-T> :tabnew .<CR>
imap <C-T> <Esc>:tabnew .<CR>
" Allow moving tabs left and right with Ctrl-Shift-Left/Right arrow
map <C-S-Left> :tabmove -1<CR>
imap <C-S-Left> <Esc>:tabmove -1<CR>
map <C-S-Right> :tabmove +1<CR>
imap <C-S-Right> <Esc>:tabmove +1<CR>

" May need this if we have arb backups laying around
"set nobackup           " Don't keep a backup file

" We want Vim to load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Setup pathogen for installing plugins in ~/.vim/bundle
execute pathogen#infect()
execute pathogen#helptags()

" Source the vimwiki configuration file if available
if filereadable($HOME . "/.vim/vimwikirc")
  source $HOME/.vim/vimwikirc
endif

