# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# Already installed?
$(command -v yazi &>/dev/null) && return 0

# On Linux this is currently only available via an official Yazi APT repository
# or Linux brew.
# We preset the THIS_INSTALLER to PKG_INSTALLER and change it for Linux if
# needed
THIS_INSTALLER=$PKG_INSTALLER

if [[ $OS =~ .*Linux ]]; then
    local IN_APT="no"
    local IN_BREW="no"

    # First check to see if yazi is available via apt if the repo has been
    # added
    $(apt search yazi 2>/dev/null | grep -q "^yazi\/") && IN_APT="yes"
    # Also check if brew is available
    $(command -v brew &>/dev/null) && IN_BREW="yes"

    if [[ $IN_APT = "no" && $IN_BREW = "no" ]]; then
        # It's not available in either
        echo -e "\nOn Linux Yazi can be installed by adding the Yazi repo:"
        echo "    https://yazi-rs.github.io/docs/installation#apt"
        echo "Follow the instructions and then run this install again."
        echo -e "\nAlternatively, it can be installed via Linux Brew."
        echo -e "You can install Linux Brew with the 'linuxbrew' component.\n"
        return 1
    fi

    # First ask before installing via brew
    if [[ $IN_BREW = "yes" ]]; then
        # Let the user know if it's available via APT also
        if [[ $IN_APT = "yes" ]]; then
            echo "Yazi is available via APT and Linux brew."
        fi
        if YesNo "Do you want to install use using Linux Brew?"; then
            # Change the installer
            THIS_INSTALLER="brew install"
        fi
    fi

    if [[ $IN_APT = "no" && $THIS_INSTALLER = $PKG_INSTALLER ]]; then
        # Does not want to install via brew, but also not available in apt
        echo "On Linux Yazi can be installed by adding the Yazi repo:"
        echo "    https://yazi-rs.github.io/docs/installation#apt"
        echo "Follow the instructions and then run this install again."
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

