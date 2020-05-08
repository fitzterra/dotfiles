#/bin/bash
#
# Script to install and manage dotfiles

##~~ Variables ~~##
# We export the variables so that the pre/post setup/remove scripts have access
# to them.
export MYDIR=$(realpath -s $(dirname $0))
export ME=$(basename $0)

# Where to install to. Can be overridden by environment variable
export INSTALLTARGET=${INSTALLTARGET:=~/}

# Declare an associative array where the keys are the component names, and the
# values are info strings about the component retrieved from the
# README.component files in their respective dirs.
declare -A COMPS

##~~ Functions ~~##

# Check that xstow is installed, and if not ask to install it
function checkXstow () {
    STOWER=xstow

    if which $STOWER >/dev/null; then
        return
    fi

    read -p "The '$STOWER' command is required. Install it now? [Y/n]: " -n 1 ans
    # Add a newline to the output only if enter was not pressed
    [ "$ans" != "" ] && echo
    # Set default answer to yes if enter was pressed and translate to lower case
    ans=$(echo ${ans:-y} | tr 'A-Z' 'a-z')

    # We can not continue if we can not install xstow
    if [ "$ans" = "n" ]; then
        echo "Using this dotfiles manager requires $STOWER. Can not continue, sorry."
        exit 1
    fi

    echo -e "Attempting to install $STOWER...\n"
    sudo apt-get install $STOWER

    if [ $? -ne 0 ]; then
        echo -e "\nCan not continue until this is fixed. Sorry..."
        exit 1
    fi
}

function usage() {
    cat << _EOU_

Installs or cleans up, all or only certain, dotfile components.

Usage: $ME [prompt|clean] [-c component] [-h]

commands:
    prompt  Interactivley set command promt color
    clean   Will clean up instead of install

options:
    -c comp,comp... Comma seperated list of components to install or clean. If
                    not supplied, all components are selected. Use -c list to
                    get a list of available components.
    -h              Show this help

environment variables:
    INSTALLTARGET   Target installation directory. Defaults to [$INSTALLTARGET]
    
_EOU_
}

##--
# Determines all available components for installation and sets the global
# COMPS array
##--
function getComponents() {
    # Components are all dirs containing a README.component file
    for c in $(find . -maxdepth 2 -name README.component); do
        comp=$(dirname $c | sed 's@^\./@@')
        COMPS[$comp]=$(cat $c)
    done
}

##--
# Show a list of all available components and their short description
##--
function showComponents() {
    echo -e "\nAvailable components:\n"
    for c in ${!COMPS[@]}; do
        printf "%-10.10s : %s\n" $c "${COMPS[$c]}"
    done
    echo
}

##--
# Install system files.
# Extepcts a source dir name containing the system files to install. The files
# in this source dir are copied to the root '/' dir, preserving the dir
# hierarchy the files live in under the source dir.
# Any existing files in the target location will be OVERWRITTEN!
# Also note that tre dir tree to which files are being coepied off the root
# ('/' ), must exist already. Trying to install a system file to the '/foo/bar'
# dir without these dirs already existing will result in an error.
function sysInstall() {
    SRC=$1
    # Ensure that SRC ends with one and only one trailing slash
    SRC="${SRC%%/*}/"

    # List of files to ignore. This could later be a file in the dir which read
    # and parsed into the structure used here.
    # For now, this is a string consisting of one or more file names separated
    # by commas (no spaces around the commas).
    # It's very crude at the moment, so extend as required.
    # Trailing comma is required.
    IGNORE_LIST="README.component,colors.sh,host_prompt_colors.dist,"

    # Find all files in the source dir, excluding any files or dirs that are
    # hidden.
    for f in $(find "$SRC" -type f -not -path '*/\.*'); do
        # Ignore it? Take the file name only and see if it exists in
        # IGNORE_LIST with a trailing comma to the name.
        if (echo $IGNORE_LIST | grep -q "$(basename $f),"); then
            continue
        fi

        # The target is the found file with the source dir part replaced by '/'
        tgt=${f/${SRC}/\/}
        sudo cp -vf $f $tgt
    done
}

##--
# Does an install - components to install are passed as arguments
##-
function install() {
    for c in $@; do
        # The `system` component gets installed as sudo since these are
        # expected to be system level files. For other components, $SUDO is
        # empty and has no effect on the subsequent command.
        [ "$c" == "system" ] && SUDO="sudo" || SUDO=""

        # Run any pre-setup scripts
        if [ -x ${c}/_pre_setup.sh ]; then
            $SUDO ${c}/_pre_setup.sh || exit 2
        fi

        # Include any component specific xstow.ini files if present
        COMPCONF=${c}/xstow.ini
        [ -f $COMPCONF ] && COMPCONF="-F $COMPCONF" || COMPCONF=""

        # Stow all files. The `system` component is installed using the
        # sysInstall function.
        if [ "$c" == "system" ]; then
            sysInstall $c || exit 1
        else
            xstow -v $COMPCONF -t $INSTALLTARGET $c || exit 1
        fi

        # Run any post-setup scripts
        if [ -x ${c}/_post_setup.sh ]; then
            $SUDO ${c}/_post_setup.sh || exit 2
        fi
    done
}

##--
# Does a cleanup - components to install are passed as arguments
# Cleanup of the system component is ignored for now
##-
function cleanup() {
    for c in $@; do
        if [ "$c" == "system" ]; then
            echo "Ignoring 'system' component in cleanup..."
        fi

        # Run any pre-remove scripts
        if [ -x ${c}/_pre_remove.sh ]; then
            ${c}/_pre_remove.sh || exit 2
        fi

        # Include any component specific xstow.ini files if present
        COMPCONF=${c}/xstow.ini
        [ -f $COMPCONF ] && COMPCONF="-F $COMPCONF" || COMPCONF=""

        xstow -v -D $COMPCONF -t $INSTALLTARGET $c || exit 1

        # Run any post-remove scripts
        if [ -x ${c}/_post_remove.sh ]; then
            $SUDO ${c}/_post_remove.sh || exit 2
        fi
    done
}

##--
# Allows interactively setting the prompt colors
##--
function setPrompt() {
    fgc=""
    bgc=""
    cOff="\e[0m"

    fgpt="\e[38;5;"
    bgpt="\e[48;5;"

    [ -z "$fgc" ] && pcol="" || pcol="${fgpt}${fgc}m"
    [ -z "$bgc" ] && pcol="${pcol}" || pcol="${pcol}${bgpt}${bgc}m"

    while true; do
        system/colors.sh
        prompt="[${USER}@${pcol}$(hostname)${cOff}:$(basename $(pwd))]$"
        echo -en "${prompt} "
        read -p "Background color (enter for none): " bgc
        read -p "Foregound color (enter for none): " fgc

        [ -z "$fgc" ] && pcol="" || pcol="${fgpt}${fgc}m"
        [ -z "$bgc" ] && pcol="${pcol}" || pcol="${pcol}${bgpt}${bgc}m"

        prompt="[${USER}@${pcol}$(hostname)${cOff}:$(basename $(pwd))]$"
        echo -en "${prompt} "
        read -p "<-- Enter 'c' to change, enter to accept: " ans
        [ -z "$ans" ] && break
    done

    # The \[ and \] symbols allow bash to understand which parts of the
    # prompt cause no cursor movement; without them, lines will wrap
    # incorrectly. See: https://mywiki.wooledge.org/BashFAQ/037
    [ -n "$pcol" ] && pcol="\[${pcol}\]" && cOff="\[${cOff}\]"

    cat > system/etc/host_prompt_colors << __EOF__
# Host prompt set using: 'install.sh prompt' from dotfiles repo
prompt: ${pcol}\h${cOff}
__EOF__

    echo -e "\nYou should run '$ME -c system' now to set the new system prompt.\n"
}

# Get all available components
getComponents

# Quick and dirty command line args parsing - starting off with an empty
# component list
while [ "$1" != "" ]; do
    case "$1" in
        -h) usage && exit 0
            ;;
        -c) shift
            [ "$1" = "list" ] && showComponents && exit 0
            # Validate each component
            for c in $(echo "$1" | tr ',' '\n'); do
                # Check if it is defined in the available components list
                if [[ ! -v "COMPS[$c]" ]]; then
                    echo "Component [$c] is not a valid component. Try -h"
                    exit 1
                fi
                # TODO: Should check if already there and not add again
                COMPLIST="$COMPLIST $c"
            done
            ;;
        prompt)
            SETPROMPT=1
            ;;
        clean)
            CLEANUP='1'
            ;;
        *) echo "Invalid argument: '$1'. Try -h" && exit 1
            ;;
    esac
    shift
done

# Use all components if none were specified
COMPLIST=${COMPLIST:-"${!COMPS[*]}"}

# I have to be run from my install dir
cd $MYDIR

# We need xstow
checkXstow

# Do the work
if [ "$SETPROMPT" = "1" ]; then
    setPrompt
elif [ "$CLEANUP" = "1" ]; then
    cleanup $COMPLIST
else
    install $COMPLIST
fi
