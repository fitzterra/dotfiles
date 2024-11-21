" Some stuff for SQL files

" Uppercase all SQL keywords in the selection

function! UppercaseSQLKeywords()
    " List of SQL Keywords
    let keywords = [
                \ 'select', 'from', 'where', 'insert', 'update',
                \ 'delete', 'create', 'drop', 'alter', 'join',
                \ 'inner', 'outer', 'left', 'right', 'full',
                \ 'group', 'order', 'by', 'having', 'limit',
                \ 'as', 'on', 'and', 'like',
                \ ]
    " We use silent to ignore any errors for keywords not found.
    " The first "'<,'>" is o ensure we only search in the visual selection, but
    " we need to use double quotes here to allow the single quotes for the
    " range characters.
    " The \< and \> searches on full words only, and \c matches lowercase only
    for keyword in keywords
        silent! execute "'<,'>" . 's/\c\<' . keyword . '\>/' . toupper(keyword) . '/g'
    endfor
endfunction

autocmd FileType sql vnoremap <leader>U :<C-u>call UppercaseSQLKeywords()<CR>

