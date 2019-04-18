#!/bin/bash
#
# This script will clean up all bundles and other auto generated files for vim
# to ensure we clean up properly when uninstalling dotfiles

# The following environment variables are inherited from our caller:
# INSTALLTARGET: The dir to which we are installing. Usually the user's home dir
# MYDIR: The dir from which the main installer runs. We are usually a sub-dir of this dir.

# Remove all dirs found in the bundle dir
BUNDLE=${INSTALLTARGET}/.vim/bundle
find $BUNDLE -maxdepth 1 ! -path $BUNDLE -type d -exec rm -rf {} \;
