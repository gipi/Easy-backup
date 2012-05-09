#!/bin/sh
#
# this checks that rsync was the only command called
# TODO: check also shell substitution
#echo "SSH_ORIGINAL_COMMAND: $SSH_ORIGINAL_COMMAND"
case "$SSH_ORIGINAL_COMMAND" in
        *\&*)
                echo "Rejected 1"
                ;;
        *\;*)
                echo "Rejected 2"
                ;;
        # the absolute path otherwise "protocol version mismatch -- is your shell clean?"
        *rdiff-backup*)
                sudo $SSH_ORIGINAL_COMMAND
                ;;
        *true*)
                echo $SSH_ORIGINAL_COMMAND
                ;;
        *)
                echo "Rejected 3"
                ;;
esac
