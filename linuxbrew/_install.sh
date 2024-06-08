# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# Only on Linux
[[ ! $OS =~ .*Linux ]] && echo "Skipping linuxbrew for non-Linux system." && return 1

# This is the command that should be available for us to continue
CMD_NAME=brew

if ! type $CMD_NAME &> /dev/null; then
    prompt="Linuxbrew is not currently installed."
    prompt="$prompt Would you like to install it now?"
    if YesNo "${prompt}"; then
        # We need curl in order to run the install command
        if ! type curl; then
            $PKG_INSTALLER curl || exit 20
        fi
        # Install it directly from their site
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 20

        # All good
        return 0
    else
        echo "Not installing or setting up Linuxbrew "
        return 1
    fi
fi

# It is installed, so all good.
return 0
