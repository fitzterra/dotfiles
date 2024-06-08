# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# Currently this is only supported on Linux. Need to test it on MacOS and adapt
# where needed before it can be supported there.
[[ $OS == Darwin ]] && echo "Powerline setup not currently supported on MacOS." && return 1

# If powerline is installed, then there will be a powerline command
CMD_NAME=powerline
# If not installed, these are the pakages we need to install
PKG_NAMES="powerline powerline-gitstatus fonts-powerline"

if ! type $CMD_NAME &> /dev/null; then
    prompt="It seems that $CMD_NAME is not currently installed."
    prompt="$prompt Would you like to install it now?"
    if YesNo "${prompt}"; then
        # Install and exit the process if installation fails
        $PKG_INSTALLER $PKG_INSTALLER_OPTS $PKG_NAMES || exit 20
        # All good
        return 0
    else
        echo "Not installing or setting up $CMD_NAME "
        return 1
    fi
fi

# It is installed, so all good.
return 0
