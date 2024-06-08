# This script is sourced from install.sh to find the default package installer,
# and optionally help installing it if not available.
#
# For now only these systems are supported:
# * Debian based Linux:
#   * For these the default package installer is `apt` and this should already
#     be installed as part of the base system
#   * On these systems Homebrew for Linux is also supported and is included as
#     the linuxbrew/ component. This component will offer to install and
#     configure homebrew on Linux systems.
# * MacOS:
#   * Only Homebrew is supported
#   * Will be asked if you want to install it if not available.

# Bash associative arrays does not maintain the order of entries added, so we
# can not use that to force preferred installers by declaring them first.
# For this reason we need to use two normal arrays. The first is the actual
# command name, and the second is the full command plus options needed for the
# installer command.
PKG_INSTALLERS=(
    "apt"   # Debian based Linux systems
    "brew"  # MacOS and Linux
)
# This is the full installer command line, in the same order as the array
# above.
PKG_INSTALLER_CMD=(
    # apt needs sudo and we also force the install without waiting for a
    # confirm prompt
    "sudo apt --yes install"
    # brew
    "brew install"
)

# We will set this to the installer command for the found installer - if any is
# found
PKG_INSTALLER=
# Loop over the installers by index and in order
for i in "${!PKG_INSTALLERS[@]}"; do
    if which "${PKG_INSTALLERS[$i]}" &>/dev/null; then
        PKG_INSTALLER="${PKG_INSTALLER_CMD[$i]}"
        break
    fi
done

# If we are on MacOS and we found the installer, we are good to go
[[ -n $PKG_INSTALLER && $OS == Darwin ]] && return 0
# If we're on Linux and we do not have an installer, we can not go on
[[ -z $PKG_INSTALLER && $OS =~ .*Linux ]] && \
    echo "Only apt based Linux systems supported currently. Exiting..." && \
    return 1

# For MacOS we can not continue without Homebrew. Offer to install it
if [[ $OS == Darwin ]]; then
    if ! YesNo "You need to install HomeBrew to continue. Install now?"; then
        echo "Can not continue without HomeBrew. Exiting..." && exit 10
    fi
    # NOTE! Not tested yet - test on MacOs system before deploying!
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    echo -e "\n\nPlease start the dotfiles setup again."
    exit 0
fi

# All good, we can continue
return 0
