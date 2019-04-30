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
" Ctrl-T opens a new tab with the file editor in the current dir in both
" normal and insert modes
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



"""""""""
" These must go into seperate vim config files, since they are either language
" dependant or for specific types of work. Just do not have time to decide
" where to put them right now....

" Insert a Python debug trace line at the current cursor position. This should
" really only be valid when in a Python file
" Key combo is <ALT-SHIFT-d>
map <A-D> <Esc>Oimport ipdb; ipdb.set_trace()<Esc>

" Remove the search highlight when pressing escape in normal mode
" From here: https://vi.stackexchange.com/a/5392
"nnoremap <Esc> :nohlsearch<return><Esc>

" Pretty format XML by pressing = on a selection
" Adaption from http://vim.wikia.com/wiki/Pretty-formatting_XML option 2
vnoremap = :!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>

" Spacebar toggels a fold open/close
nnoremap <space> za

" Auto open the quickfix/location window after :make, :grep, :lvimgrep and
" friends if there are valid locations/errors.
" From here: https://stackoverflow.com/a/39010855/10769035
augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

" Let F4 search for the word under the cursor in the current and child dirs,
" in the same type of files as being edited.
" Based on: http://vim.wikia.com/wiki/Find_in_files_within_Vim
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **/*." . expand("%:e") <Bar> cw<CR>

