" Specific settings for Python editing

" Insert a Python debug trace line at the current cursor position.
" Key combo is <ALT-SHIFT-d>
nnoremap <buffer> <A-D> <Esc>Oimport ipdb; ipdb.set_trace()<Esc>
" On MacOS I may have 'ALT' and OSX command keys swapped around, and then the
" above does not work. For this reason \d is also mapped to setting up
" debugging in Python files.
nnoremap <buffer> <Leader>d <Esc>Oimport ipdb; ipdb.set_trace()<Esc>
setlocal foldmethod=indent
" Open an ipython shell in a terminal when hitting \ip in normal more
nnoremap <Leader>ip :term ++close ipython<CR>
" Save and run the current python file with F5. See: https://stackoverflow.com/a/18948530
map <buffer> <F5> :w<CR>:exec '!/usr/bin/env python' shellescape(@%, 1)<CR>
" Map to run `make docs` - this assumes the current dir has a Makefile with a
" `docs` target for running something like pydoctor to generate docs.
" We do this in an async process
nmap <F7> :AsyncRun make docs <CR>
