#!/bin/bash
#
# For management of vim plugins, we use pathogen - see _pre_setup.sh
# This script is run after all vim dotfiles hae been installed and pathogen has
# been set up.
# The purpose of this script is to install all plugins we list here into the
# .vim/bundle dir so that they can be installed with pathogen.

# The following environment variables are inherited from our caller:
# INSTALLTARGET: The dir to which we are installing. Usually the user's home dir
# MYDIR: The dir from which the main installer runs. We are usually a sub-dir of this dir.

declare -A plugins

plugins=(
    [vim-markdown]='https://github.com/plasticboy/vim-markdown.git'
    [vim-markdown-toc]='https://github.com/ajorgensen/vim-markdown-toc.git'
    [vim-openscad]='https://github.com/sirtaj/vim-openscad.git'
)

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

