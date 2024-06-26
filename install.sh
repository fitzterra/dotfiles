#/usr/bin/env bash
#
# Script to install and manage dotfiles
#
# The shebang path above is to also support installing a newer version of bash
# on MacOS via brew, and the new version is not installed as /bin/bash

# Debug. Start as:
# $ DEBUG=1 ./install.sh
if [[ $DEBUG -eq 1 ]]; then
    set -o xtrace
fi

##~~ Variables ~~##
# The OS we are running on
OS=$(uname -o)

# We export the variables so that the pre/post setup/remove scripts have access
# to them.
export MYDIR=$(cd $(dirname $0) && pwd)
export ME=$(basename $0)

# By default we want the install to be unattended, but allow for asking certain
# questions that affect the system as a whole if the user wants it. This is via
# the -C command line option
ASK=no

# Indicates how to handle sub module checking.
# Could be one of:
#  * check - checks if submodules have been initialized and updated: default
#  * only  - only checks submodules and exits afterwards
#  * skip  - submodule checking is completely skipped
SUBMODS=check

# Where to install to. Can be overridden by environment variable
export INSTALLTARGET=${INSTALLTARGET:=~/}

# Declare an associative array where the keys are the component names, and the
# values are info strings about the component retrieved from the
# README.component files in their respective dirs.
declare -A COMPS


##~~ Functions ~~##

###
# Displays a question and accepts only yes/no input replies.
# 
# Args:
#   $1 : The prompt to display
#
# Returns:
#  0 for Yes or 1 for No
###
function YesNo () {
    prompt="$1 (y/n): "
    ans=

    while [[ $ans != 'y' && $ans != 'n' ]]; do
        read -p "$prompt" -N 1 ans
        echo ""
        case $ans in
            "y" | "Y" ) return 0 ;;
            "n" | "N" ) return 1 ;;
        esac
        echo "Invalid response. Please answer with y or n only."
    done
}

# Check that stow is installed, and if not ask to install it
function checkStow () {
    STOWER=stow

    if which $STOWER >/dev/null; then
        return
    fi

    if [[ $ASK = "yes" ]]; then
        read -p "The '$STOWER' command is required. Install it now? [Y/n]: " -n 1 ans
        # Add a newline to the output only if enter was not pressed
        [ "$ans" != "" ] && echo
        # Set default answer to yes if enter was pressed and translate to lower case
        ans=$(echo ${ans:-y} | tr 'A-Z' 'a-z')

        # We can not continue if we can not install $STOWER
        if [ "$ans" = "n" ]; then
            echo "Using this dotfiles manager requires $STOWER. Can not continue, sorry."
            exit 1
        fi
    fi

    echo -e "Attempting to install $STOWER...\n"
    $PKG_INSTALLER $STOWER

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
    -C              Ask to confirm for certain action that affect the system
                    as a whole. Default is for unattended install, so no
                    confirmations are asked for.
    -s              Check submodules only and exit on completion.
    -S              Skip submodule check completely.
    -h              Show this help

environment variables:
    INSTALLTARGET   Target installation directory. Defaults to [$INSTALLTARGET]

_EOU_
}

##--
# Checks if any git sub modules needs to be initialised/updated.
# It is easy to forget to do this after a clone if --recurse-submodules have
# not been specified for the clone command
##--
function checkSubmodules () {
    echo "Checking submodules..."

    git submodule status | (
        # We set this inside this block to be used as the return value for the
        # parent to test
        must_init=0

        # The submodule status output is 3 parts: hash, submodule and the git
        # describe output for the checkout
        while read hash mod desc; do
            # If the desc value is empty, the submodule needs to be initialised
            if [[ -z $desc ]]; then
                echo "   Submodule $mod needs to be initialiesd."
                must_init=1
            fi
        done
        # Use $must_init as the return code
        return $must_init
    )

    [[ $? -eq 0 ]] && return

    prompt="One or more submodules need to be initialised. Do you want to do this now?"
    if ! YesNo "$prompt"; then
        echo "Functionality will be limited until submodules are initialized."
        return
    fi

    git submodule init
    git submodule update
}

##--
# Determines all available components for installation and sets the global
# COMPS array
##--
function getComponents() {
    # Components are all dirs containing a README.component file
    for c in $(find $MYDIR -maxdepth 2 -name README.component); do
        comp=$(dirname $c | sed 's@^.*/@@')
        COMPS[$comp]=$(head -n 1 $c)
    done

    echo "Components found: ${!COMPS[@]}"
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
# Creates ~/.config if it does not exist as a dir.
# Some of the components has config files or dirs that needs to go into
# ~/.config - if this dir does not exist already when such a component is
# installed, stow will link the .config dir in the component to ~/.config
# instead of the component subdir inside .config.
# This means that anything ne installed in ~/.config is going to use the linked
# .config dir which is now inside the component dir in the repo.
#--
function setupDotConfig() {
    CONF=~/.config

    # It must be a dir, but not a symlink to a dir
    if [[ -d $CONF && ! -L $CONF ]]; then
        # It's a dir, so all good
        return
    fi

    # If it exists, it means it's not a dir, so we have a problem
    if [[ -e $CONF ]]; then
        echo "Found a $CONF entry which is not a dir."
        echo "Some components requires $CONF to exist as a dir, so we"\
             "can not continue at this point."
        exit 3
    fi

    # Create it
    mkdir -v $CONF || exit 4
}

##--
# Does an install - components to install are passed as arguments
##-
function install() {
    for c in $@; do
        echo -e "\n++++++++++++++++++++\nInstalling component: $c"

        # If an _install.sh script is available, source it to allow installing
        # this component if not already available.
        if [[ -f ${c}/_install.sh ]]; then
            # If install does not return success (0), we skip this component
            # setup entirely
            source ${c}/_install.sh || continue
        fi

        # Run any pre-setup scripts
        if [ -x ${c}/_pre_setup.sh ]; then
            ${c}/_pre_setup.sh || exit 2
        fi

        # Stow all files.
        stow -v -d $MYDIR -t $INSTALLTARGET $c || exit 1

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
        echo -e "\n++++++++++++++++++++\nCleaning up component: $c"

        # Run any pre-remove scripts
        if [ -x ${c}/_pre_remove.sh ]; then
            ${c}/_pre_remove.sh || exit 2
        fi

        # Remove the stowed files.
        stow -v -d $MYDIR -t $INSTALLTARGET -D $c || exit 1

        # Run any post-remove scripts
        if [ -x ${c}/_post_remove.sh ]; then
            ${c}/_post_remove.sh || exit 2
        fi
    done
}

############################## MAIN ##################################

# Source package installer script to find the correct package installer based
# on the system we're running on. We exit if no installer is found.
source find_installer.sh || exit 1
echo "Package installer: $PKG_INSTALLER"

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
        -C)
            ASK=yes
            ;;
        -s)
            SUBMODS=only
            ;;
        -S)
            SUBMODS=skip
            ;;
        clean)
            CLEANUP='1'
            ;;
        *) echo "Invalid argument: '$1'. Try -h" && exit 1
            ;;
    esac
    shift
done

# Check git submodules
if [[ $SUBMODS != "skip" ]]; then
    checkSubmodules || exit 1
    [[ $SUBMODS == "only" ]] && exit 0
fi

# Use all components if none were specified
COMPLIST=${COMPLIST:-"${!COMPS[*]}"}

# I have to be run from my install dir
cd $MYDIR

# We need a stower
checkStow

# Depending on the stower, it may not like comments in .stowrc, so we save
# .stowrc as dot.stowrc where we allow comments to make things easier to
# understand. This is where we then create .stowrc from dot.stowrc by
# stripping all comments from dot.stowrc and then saving it as .stowrc.
grep -v "#" dot.stowrc > .stowrc

# Do the work
if [ "$CLEANUP" = "1" ]; then
    cleanup $COMPLIST
else
    # We need ~/.config to be set up correctly
    setupDotConfig
    install $COMPLIST
fi
