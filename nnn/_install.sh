# Checks if this component is installed and offers to install it if not.
# Returns:
#   0 : If the command is available
#   1 : If not and we will not be installing it now. This tells the installer
#       to not do any further configuration for this component.
#
# Exits the installation on any error

# This is both the command name and the name for the package to install.
PKG_NAME=nnn

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

# We need curl for installing nnn plugins
if ! type curl; then
    $PKG_INSTALLER curl || exit 20
fi

# Install or update plugins. See: https://github.com/jarun/nnn/tree/master/plugins#installation
echo -e "\nInstalling/Updating nnn plugins. If asked, user overwrite (o) to update plugins.\n"
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)" || exit 20

# The plugins will be installed to ~/.config/nnn/plugins . We use the nuke
# plugin as our file opener, but currently it opens text and log files in the
# editor, which is not the best. We want these to open in the pager which is
# `less`. From the pager we can always open in the editor if need be.
# To fix this, we will replace all instances where the EDITOR is used to open a
# file with the less command.
# CAVEAT NOTE:
#   The nuke plugin does define a PAGER as 'less -R' but for some reason when
#   defining a command line this and then trying to use it as an executable,
#   bash sees the full string including the `-R` bit as the command name and
#   then fails with command not found.
#   This is weird as shit since I'm sure I have done it like this before, but
#   for the life of me I can not get this to work by replacing "$EDITOR" with
#   "$PAGER" in the script. The $EDITOR works because it defaults to just the
#   command 'vi'. The failure happens as soon as the command has additional
#   arguments.
#   Anyway, so until I can figure this out, I'm just using `less -SR` directly
#   as the opener to replace "$EDITOR" with.
echo "Fixing nnn nuke pluging for opening text and log files."
sed -i 's/"\$EDITOR" "\${FPATH}"/less -SR "\${FPATH}"/' ~/.config/nnn/plugins/nuke || exit 20

# It is installed, so all good.
return 0
