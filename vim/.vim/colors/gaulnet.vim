" The GaulNet color scheme
" Created from my own color preferences, with help from here:
" https://www.codementor.io/sandeepkumar4/vimleaning-how-to-create-vim-color-scheme-j7lmp1xkc

" First, we need to clear any predefined colors or background.
highlight clear
if exists("syntax_on")
  syntax reset
endif

set background=dark
let g:colors_name="gaulnet"

" Cornerstone for setting colors
"
" Args:
"   group: highlight group - required
"   guibg: gui background color - required, empty string if not needed
"   guifg: gui foreground color - required, empty string if not needed
"   gui:   gui color - optional
function! s:GuiFor(group, ...)
  let histring = 'hi ' . a:group . ' '

  if strlen(a:1)
    let histring .= 'guibg=' . a:1 . ' '
  endif

  if strlen(a:2)
    let histring .= 'guifg=' . a:2 . ' '
  endif

  if a:0 >= 3 && strlen(a:3)
    let histring .= 'gui=' . a:3 . ' '
  endif

  execute histring
endfunction

" --- The color scheme --
call s:GuiFor("Normal", "gray20", "White")
call s:GuiFor("Cursor", "Green", "NONE")
call s:GuiFor("NonText", "gray25", "")
call s:GuiFor("Constant", "gray22", "", "NONE")
call s:GuiFor("Special", "grey30", "", "NONE")
call s:GuiFor("Search", "OldLace", "")
call s:GuiFor("Search", "OldLace", "RoyalBlue")
call s:GuiFor("Folded", "gray40", "white")
call s:GuiFor("FoldColumn", "gray40", "white")


" ColorColumn needs version 7.3+
if v:version >= 730
    set colorcolumn=80		" Adds a visual indicater to column 80
    " Set the visual indicator column color for term and GUI
    highlight ColorColumn ctermbg=brown guibg=#2c2c2c
endif

