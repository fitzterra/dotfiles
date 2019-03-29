#/bin/bash
#
# Script to install and manage dotfiles

##~~ Variables ~~##
MYDIR=$(dirname $0)
ME=$(basename $0)
# Declare an associative array where the keys are the component names, and the
# values are info strings about the component retrieved from the
# README.component files in their respective dirs.
declare -A COMPS

##~~ Functions ~~##
function setBashRcHook ()
{
	# This function appends the data in $HOOK to the end of the files in
	# $FILES. If the specific .bashrc already has the $SIGs signature, it
	# is skipped and nothing is appended.
    # Technically it is meant to only add a hook to the end of ~/.bashrc to
    # source our own rc file, but it can be generalized to do all .bashrc's in
    # all home dirs for example - if has the versatility if needed.
    #
    # Passing an argument of -d will remove any hooks (with both start and end
    # signatures in tact) from the file(s)
	
	##~~ Variables ~~##
	SIGs='###-DF:HOOK'
	SIGe='###-FD:KOOH'
	HOOK=$(
cat <<__HOOK__

$SIGs -- do not remove. added by $(basename $0)
# Source the local config changes file if it exists
[ -f ~/.bashrc_local ] && . ~/.bashrc_local
$SIGe -- do not remove - hook end

__HOOK__
)
    # If $HOOKFILES is defined we get the list of files from there, else
    # default to ~/.bashrc
	FILES=${HOOKFILES:-~/.bashrc}
	
	# Update all files
	for f in $FILES; do
		# Ignore it if it does not exist
		[ ! -f "$f" ] && continue

        # Remove?
        if [ "$1" = "-d" ]; then
            echo -n "Removing hook from $f: ..."
            # This can probably be done with sed alone, but I do not know sed
            # well enough :-(
            # The intent is to use se'd line matching to only delete the lines
            # between the start and end sigs. This works fine unless the end
            # sig is not found in which case all the lines from start to end
            # sig will be deleted - how do you make sed NOT to the job unless
            # the las line spec is also found?
            # My dirty solution is to use sed to match and output only the
            # block between the sigs. This output is then grep'ed for the end
            # sig. If found, we know the block is good and we can do another
            # proper delete using sed.
            if (sed -n "/${SIGs}/,/${SIGe}/p" $f | grep -q "$SIGe"); then
                sed -i.bak "/${SIGs}/,/${SIGe}/d" $f
                echo " done. Original was backed up."
            else
                echo " not found, or hook signatures are invalid." 
            fi
        else
            echo -n "Setting up: $f ..."
            if grep -q "$SIGs" $f ; then
                echo "Already contains hook."
                continue
            fi
	
            echo "$HOOK" >> $f || exit 1
            echo " done."
        fi
	done
}

# Check that xstow is installed, and if not ask to install it
function checkXstow () {
    STOWER=xstow

    if (which $STOWER >/dev/null); then
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
        case "$c" in
            bash)
                # We need to also do the bashrc hook
                setBashRcHook
                xstow -v -i README.component -t ~/ $c || exit 1
                ;;
            *)
                # Anything else is just a stow away
                xstow -v -i README.component -t ~/ $c || exit 1
        esac
    done
}

##--
# Does a cleanup - components to install are passed as arguments
##-
function cleanup() {
    for c in $@; do
        case "$c" in
            bash)
                # We need to also do the bashrc hook
                setBashRcHook -d
                xstow -v -D -i README.component -t ~/ $c || exit 1
                ;;
            *)
                # Anything else is just a stow away
                xstow -v -D -i README.component -t ~/ $c || exit 1
        esac
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
