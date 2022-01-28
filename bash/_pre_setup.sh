#!/usr/bin/env bash
#
# Adds or removes the bash hook to .bashrc
# This script is called _pre_setup.sh which indicates that when called, it
# should try to add the hook.
# This same script can also be used to remove the hook, by creating a symlink
# link to it called _post_remove.sh. If called _post_remove.sh, then the hook
# will be removed.
# On MacOS (Montery onwards at least) there is no .bashrc file, but it will be
# created if it does not exist.

# The following environment variables are inherited from our caller:
# INSTALLTARGET: The dir to which we are installing. Usually the user's home dir
# MYDIR: The dir from which the main installer runs. We are usually a sub-dir of this dir.

function setBashRcHook ()
{
    # This function appends the data in $HOOK to the end of the .bashrc file
    # found in the $INSTALLTARGET dir. If the specific .bashrc already has the
    # $SIGs signature, it is skipped and nothing is appended.
    #
    # Passing an argument of -d will remove any hooks (with both start and end
    # signatures in tact) from the file(s)
	
	##~~ Variables ~~##
	SIGs='###-DF:HOOK'
	SIGe='###-FD:KOOH'
	HOOK=$(
cat <<__HOOK__

$SIGs -- do not remove. added by $(basename $0)
# Source the local config changes file if it exists
[ -f ~/.bashrc_local ] && . ~/.bashrc_local
$SIGe -- do not remove - hook end

__HOOK__
)
    # Point to the RC file we'll be modifying
    RCFILE=${INSTALLTARGET}/.bashrc

    # Remove?
    if [ "$1" = "-d" ]; then
        echo -n "Removing hook from $RCFILE: ..."
        # This can probably be done with sed alone, but I do not know sed
        # well enough :-(
        # The intent is to use sed's line matching to only delete the lines
        # between the start and end sigs. This works fine unless the end
        # sig is not found in which case all the lines from start to end
        # sig will be deleted - how do you make sed NOT to the job unless
        # the last line spec is also found?
        # My dirty solution is to use sed to match and output only the
        # block between the sigs. This output is then grep'ed for the end
        # sig. If found, we know the block is good and we can do another
        # proper delete using sed.
        # Time te re-learn awk??
        if (sed -n "/${SIGs}/,/${SIGe}/p" $RCFILE | grep -q "$SIGe"); then
            sed -i.bak "/${SIGs}/,/${SIGe}/d" $RCFILE
            echo " done. Original was backed up."
        else
            echo " not found, or hook signatures are invalid." 
        fi
    else
        echo -n "Setting up: $RCFILE ..."
        if grep -q "$SIGs" $RCFILE ; then
            echo "Already contains hook."
            return
        fi

        echo "$HOOK" >> $RCFILE || exit 1
        echo " done."
    fi
}

MYNAME=$(basename $0)
ARGS=

if [ "$MYNAME" = "_post_remove.sh" ]; then
    ARGS=-d
fi

# Do it
setBashRcHook $ARGS

