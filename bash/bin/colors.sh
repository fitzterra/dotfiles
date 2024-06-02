#!/bin/bash

function ansi_colors () {
    width=15   # This is zero based...

    printf "\n        %s\n\n" "Color escape chart."
    printf "    " 
    for n in $(seq 0 ${width}); do
        printf "  %3d  " $n
    done
    printf "\n"

    fore="38;5;"
    back="48;5;"

    color=0
    while [ $color -lt 255 ]; do
        printf "%3d:" $color
        for n in $(seq 0 $width); do
            printf " \\033[${fore}${color}m%3d\\033[${back}${color}m---\\033[0m" $color
            ((color++))
            if [ $color -ge 255 ]; then
                break;
            fi
        done
        printf "\n"
    done
    
    echo -e '\n\nExample: echo -e "\\\\033['${fore}'_fg_;'${back}'_bg_mText in color\\\\033[0m"\n\n'
}



function tmux_colors () {
    w=8; wc=0
    for i in {0..255}; do
      printf "\x1b[38;5;${i}mcolour%-3s\x1b[0m" "$i"; wc=$((wc+1));
      if [ $wc -lt $w ]; then printf " | "; else printf "\n"; wc=0; fi;
    done
}

[[ $1 == 'ansi' ]] && ansi_colors && exit 0
[[ $1 == 'tmux' ]] && tmux_colors && exit 0

echo -e "\nUse arg 'ansi' for ANSI escape colors, or arg 'tmux' for tmux colors\n"
exit 1
