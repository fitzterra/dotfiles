" Allows centering the text in the visual selection.
" See here for more: https://stackoverflow.com/a/26140622

function! GetVisual()
    try
        let v_save = @v
        normal! gv"vy
        return @v
    finally
        let @v = v_save
    endtry
endfunction

fun! CenterMe()
    let v = GetVisual()
    "let l = getline('.')
    let lre = '^\zs\s*\ze\S'
    let rre = '\s*$'
    let sp= matchstr(v,lre)
    let sp .= matchstr(v,rre)
    let ln=len(sp)
    let v = substitute(v,lre,sp[:ln/2-1],'')
    let v = substitute(v,rre,sp[ln/2:],'')
    let ve_save = &virtualedit
    let v_save = @v
    let &virtualedit = 'all'
    call setreg('v', v,visualmode())
    normal! gvx"vP
    let @v = v_save
    let &virtualedit = ve_save
endf

" Map it to CTRL-^ only for visual mode
xnoremap <C-^> :call CenterMe()<CR>
