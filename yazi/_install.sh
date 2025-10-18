# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# on Linux this is currently only available via Linux brew. If brew is
# available we will use that for install.
# We preset the THIS_INSTALLER to PKG_INSTALLER and change it for Linux if
# needed
THIS_INSTALLER=$PKG_INSTALLER

if [[ $OS =~ .*Linux ]]; then
    if ! which brew &> /dev/null; then
        echo "On Linux, Yazi can only be installed via Linux Brew."
        echo "You can install Linux Brew with the 'linuxbrew' component."
        return 1
    fi
    echo "On Linux we can currently only install Yazi via Linux Brew."
    if YesNo "Do you want to use use Linux Brew?"; then
        THIS_INSTALLER="brew install"
    else
        return 1
    fi
fi

# This is both the command name and the name for the package to install.
PKG_NAME=yazi

if ! type $PKG_NAME &> /dev/null; then
    prompt="The $PKG_NAME command is not currently installed."
    prompt="$prompt Would you like to install it now?"
    if YesNo "${prompt}"; then
        # Install and exit the process if installation fails
        $THIS_INSTALLER $PKG_NAME || exit 20
    else
        echo "Not installing or setting up $PKG_NAME "
        return 1
    fi
fi

