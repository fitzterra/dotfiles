# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# This is the command name that indicates lazygit is installed
CMD_NAME=lazygit

# If installed, all is good and we go out
if type $CMD_NAME &> /dev/null; then
    return 0
fi

# We may change the installer for linux, but we do not want to change the
# exported PKG_INSTALLER, so we copy to a new name here and will use this name
# as the installer later.
LG_INSTALLER="$PKG_INSTALLER"

# Currently lazygit is not available in a Debian repo, but it can be installed
# from linuxbrew.
if [[ $OS =~ .*Linux ]]; then
    # If brew is not available, we can not continue
    if ! type brew &> /dev/null; then
        echo -e "\nLazygit on Linux only installable via brew currently, Linuxbrew is not installed. Skipping..."
        return 1
    fi
    # Change the installer on the fly so this works on both Linux and MacOS
    LG_INSTALLER="brew install"
fi

prompt="The $CMD_NAME command is not currently installed."
prompt="$prompt Would you like to install it now?"
if YesNo "${prompt}"; then
    # Install and exit the process if installation fails
    $LG_INSTALLER $CMD_NAME || exit 20
else
    echo "Not installing or setting up $CMD_NAME "
    return 1
fi

# It is installed, so all good.
return 0
