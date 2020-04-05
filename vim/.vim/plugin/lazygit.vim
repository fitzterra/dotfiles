" Keybinding to open lazygit in a terminal window inside vim if lazygit is
" available as the 'lg' command.
" LazyGit: https://github.com/jesseduffield/lazygit
" This could be improved a lot more, but for now on my systems, LazyGit is
" installed as an AppImage, and I have a symlink to it as ~/bin/lg with '~/bin'
" in my $PATH.
" So it an executable called 'lg' is available, we set up the binding
if executable('lg')
    " Open the terminal when entering the key sequence \lg in command mode,
    " closing the terminal on exit from the command agin.
    nnoremap <Leader>lg :term ++close lg<CR>
endif
