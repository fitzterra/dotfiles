# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# Currently this is only supported on Linux. Need to test it on MacOS and adapt
# where needed before it can be supported there.
[[ $OS != Darwin ]] && echo "Yazi auto install only available on MacOs right now." && return 1

# This is both the command name and the name for the package to install.
PKG_NAME=yazi

if ! type $PKG_NAME &> /dev/null; then
    prompt="The $PKG_NAME command is not currently installed."
    prompt="$prompt Would you like to install it now?"
    if YesNo "${prompt}"; then
        # Install and exit the process if installation fails
        $PKG_INSTALLER $PKG_NAME || exit 20
    else
        echo "Not installing or setting up $PKG_NAME "
        return 1
    fi
fi

