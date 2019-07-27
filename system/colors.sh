#!/bin/bash

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
