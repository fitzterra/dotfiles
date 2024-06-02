#!/bin/bash
#
# After having installed tmux, and symlinking the ~/.tmux dir, we auto install
# all tmux plugins as set in the config file.

# The following environment variables are inherited from our caller:
# INSTALLTARGET: The dir to which we are installing. Usually the user's home dir
# MYDIR: The dir from which the main installer runs. We are usually a sub-dir of this dir.

# This is the full path to where we will expect the TPM (https://github.com/tmux-plugins/tpm)
# plugins installer to be found.
INSTALLER=${INSTALLTARGET}/.tmux/plugins/tpm/bin/install_plugins

# If the installer is not found, we can exit
[ ! -f $INSTALLER ] && echo "No tmux TPM plugin installer found." && exit 0

# Plugins can be installed without being inside a tmux session
$INSTALLER
