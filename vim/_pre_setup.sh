#!/bin/bash
#
# For management of vim plugins, we use pathogen, and specifically, the Debian
# vim-pathogen package since we only cater for Debian for now.
# This pre-setup script will install this package if it is not installed, and
# activate it via the Debian vim-addons manager....

# This script is called _pre_setup.sh which indicates that when called, it
# should try to add the hook.
# This same script can also be used to remove the hook, by creating a symlink
# link to it called _post_remove.sh. If called _post_remove.sh, then the hook
# will be removed.

# The following environment variables are inherited from our caller:
# INSTALLTARGET: The dir to which we are installing. Usually the user's home dir
# MYDIR: The dir from which the main installer runs. We are usually a sub-dir of this dir.

# Check that vim-pathogen is installed, and if not ask to install it
function checkPathogen () {
    PKG=vim-pathogen

    if dpkg -s $PKG >/dev/null 2>&1; then
        return
    fi

    read -p "The '$PKG' package is required. Install it now? [Y/n]: " -n 1 ans
    # Add a newline to the output only if enter was not pressed
    [ "$ans" != "" ] && echo
    # Set default answer to yes if enter was pressed and translate to lower case
    ans=$(echo ${ans:-y} | tr 'A-Z' 'a-z')

    # We can not continue if we can not install it
    if [ "$ans" = "n" ]; then
        echo "Using Vim plugins requires $PKG. Can not continue, sorry."
        exit 1
    fi

    echo -e "Attempting to install $PKG...\n"
    sudo apt-get install $PKG

    if [ $? -ne 0 ]; then
        echo -e "\nCan not continue until this is fixed. Sorry..."
        exit 1
    fi
}

checkPathogen
