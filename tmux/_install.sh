# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# This is both the command name and the name for the package to install.
PKG_NAME=tmux

if ! type $PKG_NAME &> /dev/null; then
    prompt="The $PKG_NAME command is not currently installed."
    prompt="$prompt Would you like to install it now?"
    if YesNo "${prompt}"; then
        # Install and exit the process if installation fails
        $PKG_INSTALLER $PKG_NAME || exit 20
        # All good
        return 0
    else
        echo "Not installing or setting up $PKG_NAME "
        return 1
    fi
fi

# It is installed, so all good.
return 0
