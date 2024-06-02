#!/usr/bin/env bash
#
# For management of vim plugins, we use pathogen - see _pre_setup.sh
# This script is run after all vim dotfiles have been installed and pathogen has
# been set up.
# The purpose of this script is to install all plugins declared in the
# plugins.txt file, into .vim/bundle dir so that they can be installed with
# pathogen.

# The following environment variables are inherited from our caller:
# INSTALLTARGET: The dir to which we are installing. Usually the user's home dir
# MYDIR: The dir from which the main installer runs. We are usually a sub-dir of this dir.

THISDIR=$(dirname $0)

# If there is no plugins.txt file, then we can exit
PLUGINS=${THISDIR}/plugins.txt
[[ ! -f $PLUGINS ]] && echo "No vim plugins list found." && exit 0

# Source the plugins, which will bring in the $plugins array
source $PLUGINS

# The dir we clone the bundles to
BUNDLE=${INSTALLTARGET}/.vim/bundle
[ ! -d $BUNDLE ] && echo -e "\nVim bundle dir does not exist: $BUNDLE \n" && exit 1

for p in ${!plugins[*]}; do
    echo -e -n "\nInstalling vim plugin: $p (${plugins[$p]}) ..."
    if [ -d ${BUNDLE}/${p} ] ; then
        echo "already here... ignoring."
        continue
    else
        echo
    fi

    git clone ${plugins[$p]} ${BUNDLE}/${p}
done

