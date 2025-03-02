"
" Local Vim config
"

" Setup pathogen for installing plugins in ~/.vim/bundle
execute pathogen#infect()
execute pathogen#helptags()

" We want syntax highligting on
syntax on

" We prefer a dark background and dark color scheme. Ensure that this is the
" case no matter where we start (g)vim
set background=dark

" Set a color scheme
"colorscheme desert
"colorscheme apprentice
"colorscheme PaperColor
colorscheme iceberg

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
set tw=79               " Limit lines to 79 chars long by default
set splitright          " Always put new vertical split windows to the right
set splitbelow          " Always put new horizontal split windows below the current window

" Make folding available but leave it manual unless overridden by a syntax file
set foldmethod=manual
set foldcolumn=3
" Not sure how this works with the foldmethod above, but the idea is to set the
" foldmethod for the local buffer to use it's designated syntax foldmethod.
" This auto folds C and C++ files for example since a fold handler for these
" are already present.
setlocal foldmethod=syntax
" This is when syntax highlighting gets screwed up with folding large files.
" Fix it with Shift-u     See: https://vi.stackexchange.com/a/2174 
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

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
" Ctrl-T opens a new empty tab normal and insert modes
map <C-T> :tabnew<CR>
imap <C-T> <Esc>:tabnew<CR>
" Leader-t opens a new tab with the file editor in the current dir in both
" normal and insert modes
nnoremap <Leader>t :tabnew .<CR>
nnoremap <Leader>T :Texplore<CR>
" Allow moving tabs left and right with Ctrl-Shift-Left/Right arrow
map <C-S-Left> :tabmove -1<CR>
imap <C-S-Left> <Esc>:tabmove -1<CR>
map <C-S-Right> :tabmove +1<CR>
imap <C-S-Right> <Esc>:tabmove +1<CR>
" Poor man's zoom window with Ctrl-W z ala tmux.
" All this does is edit the current window in a new tab. When done, just close
" the tab and the original window split for this buffer is still there
nnoremap <C-W>z :tabedit %<CR>

" May need this if we have arb backups laying around
"set nobackup           " Don't keep a backup file

" We want Vim to load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

">>>>>>>>>>>>> NetRW Settings <<<<<<<<<<<<<<"
" Set the tree listing style from file browsing
let g:netrw_liststyle= 3

">>>>>>>>>>>>> General <<<<<<<<<<<<<<"
" Clear search highlighting with escape.
" This works fine in gvim
if has('gui_running')
    nnoremap <esc> :noh<CR><ESC>
else
    " This work in terminal vim - CTRL + /  (not sure why it has to be mapped
    " as <C-_> ...
    nnoremap <C-_> :noh<CR>
endif
" Always enable spell, and set a local spell file. The idea is that the
" spellfile should normally be a hidden file in the project and can be ignored
" by .gitignore in git repo
set spell
set spellfile=.vim-spellfile.add

" Pretty format XML by pressing = on a selection
" Adaption from http://vim.wikia.com/wiki/Pretty-formatting_XML option 2
vnoremap = :!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>
" Pretty format JSON by pressing + on a selection
" Adaption from http://vim.wikia.com/wiki/Pretty-formatting_XML option 2
vnoremap + :!python -c "import json, sys; print(json.dumps(json.load(sys.stdin), indent=4))"<CR>

" Spacebar toggels a fold open/close
nnoremap <space> za
" Shift-Spacebar toggels a fold open/close recursively
nnoremap <S-space> zA

" Auto open the quickfix/location window after :make, :grep, :lvimgrep and
" friends if there are valid locations/errors.
" From here: https://stackoverflow.com/a/39010855/10769035
augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

" Set vim.ack to use the faster `ag` instead of `ack` - this needs the
" silversearcher-ag package to be installed
let g:ackprg = 'ag --vimgrep'

" Let F4 search for the word under the cursor in the current and child dirs,
" in the same type of files as being edited.
" Based on: http://vim.wikia.com/wiki/Find_in_files_within_Vim
"map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **/*." . expand("%:e") <Bar> cw<CR>
" Instead of vim grep, use ack.vim and so `ag` for much faster searches
"map <F4> :execute "Ack! " . expand("<cword>") <CR>
" Make it even better by using Ag from fzf.vim to use fzf for the result
map <F4> :execute "Ag " . expand("<cword>") <CR>

" Function to strip trailing whitespace from files, usually on save, preserving
" the current cursor localtion in doing so.
" See: https://stackoverflow.com/a/1618401
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun
"autocmd FileType c,cpp,python,bash,sh autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Rebuild the tags file with \bt
nnoremap <Leader>bt :AsyncRun ctags -R .<CR>

">>>>>>>>>>>>> Dot/Graphviz Files <<<<<<<<<<<<<<"
" Compile the current graph. This requires the vim graphviz plugin from
" https://github.com/liuchengxu/graphviz.vim to be installed.
" A good workflow is to compile the graph, then open it in a PDF viewer next
" to the vim window. Whenever you compile it will be update in the pdf viewer
autocmd FileType dot nnoremap <buffer> <F9> :w<CR>:GraphvizCompile dot pdf<CR>

