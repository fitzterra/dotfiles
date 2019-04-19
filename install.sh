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

Usage: $ME [clean] [-c component] [-h]

commands:
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
# Does an install - components to install are passed as arguments
##-
function install() {
    for c in $@; do
        # Run any pre-setup scripts
        if [ -x ${c}/_pre_setup.sh ]; then
            ${c}/_pre_setup.sh || exit 2
        fi

        # Include any component specific xstow.ini files if present
        COMPCONF=${c}/xstow.ini
        echo "COMPCONF = $COMPCONF"
        [ -f $COMPCONF ] && COMPCONF="-F $COMPCONF" || COMPCONF=""
        echo "COMPCONF = $COMPCONF"

        # Stow all files
        xstow -v $COMPCONF -t $INSTALLTARGET $c || exit 1

        # Run any post-setup scripts
        if [ -x ${c}/_post_setup.sh ]; then
            ${c}/_post_setup.sh || exit 2
        fi
    done
}

##--
# Does a cleanup - components to install are passed as arguments
##-
function cleanup() {
    for c in $@; do
        # Run any pre-remove scripts
        if [ -x ${c}/_pre_remove.sh ]; then
            ${c}/_pre_remove.sh || exit 2
        fi

        # Include any component specific xstow.ini files if present
        COMPCONF=${c}/xstow.ini
        [ -f $COMPCONF ] && COMPCONF="-F $COMPCONF" || COMPCONF=""

        # Stow all files
        xstow -v -D $COMPCONF -t $INSTALLTARGET $c || exit 1

        # Run any post-remove scripts
        if [ -x ${c}/_post_remove.sh ]; then
            ${c}/_post_remove.sh || exit 2
        fi
    done
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
if [ "$CLEANUP" = "" ]; then
    install $COMPLIST
else
    cleanup $COMPLIST
fi
