#/bin/bash
#
# Script to install and manage dotfiles

##~~ Variables ~~##
MYDIR=$(dirname $0)

##~~ Functions ~~##
function setBashRcHook ()
{
	# This function appends the data in $HOOK to the end of the files in
	# $FILES. If the specific .bashrc already has the $SIGs signature, it
	# is skipped and nothing is appended.
    # Technically it is meant to only add a hook to the end of ~/.bashrc to
    # source our own rc file, but it can be generalized to do all .bashrc's in
    # all home dirs for example - if has the versatility if needed.
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
    # If $HOOKFILES is defined we get the list of files from there, else
    # default to ~/.bashrc
	FILES=${HOOKFILES:-~/.bashrc}
	
	# Update all files
	for f in $FILES; do
		# Ignore it if it does not exist
		[ ! -f "$f" ] && continue

        # Remove?
        if [ "$1" = "-d" ]; then
            echo -n "Removing hook from $f: ..."
            # This can probably be done with sed alone, but I do not know sed
            # well enough :-(
            # The intent is to use se'd line matching to only delete the lines
            # between the start and end sigs. This works fine unless the end
            # sig is not found in which case all the lines from start to end
            # sig will be deleted - how do you make sed NOT to the job unless
            # the las line spec is also found?
            # My dirty solution is to use sed to match and output only the
            # block between the sigs. This output is then grep'ed for the end
            # sig. If found, we know the block is good and we can do another
            # proper delete using sed.
            if (sed -n "/${SIGs}/,/${SIGe}/p" $f | grep -q "$SIGe"); then
                sed -i.bak "/${SIGs}/,/${SIGe}/d" $f
                echo " done. Original was backed up."
            else
                echo " not found, or hook signatures are invalid." 
            fi
        else
            echo -n "Setting up: $f ..."
            if grep -q "$SIGs" $f ; then
                echo "Already contains hook."
                continue
            fi
	
            echo "$HOOK" >> $f || exit 1
            echo " done."
        fi
	done
}

HOOKFILES=hooktest.txt
setBashRcHook $@
