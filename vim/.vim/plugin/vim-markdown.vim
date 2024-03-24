" Folding in markdown files is irritating at best, as set up by the
" vim-markdown plugin.
" Disable folding completely.
" Try `:help vim-markdown-disable-folding`
"let g:vim_markdown_folding_disabled = 1

" To previeww the markdown file, the following is required:
" grip: https://github.com/joeyespo/grip
"       This app will start a local HTTP server, convert a markdown file to
"       HTML via GitHub, using GitHub flavoured markdown, and then open a
"       browser window to the local HTTP server to show the markdown file. The
"       browser will auto update as the file is changed and saved.
" asynrun: https://github.com/skywind3000/asyncrun.vim
"       Very useful VIM plugin to run tasks in the backgroun. This will be used
"       to start the grip server in the background, and display it's output in
"       the quickfix window
"
" Map F5 to Mardown preview as an asyn grip process
autocmd FileType markdown nmap <F5> :AsyncRun -cwd=$(VIM_FILE_DIR) grip -b $(VIM_FILENAME) <CR>
