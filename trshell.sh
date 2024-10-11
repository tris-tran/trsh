#!/bin/bash
#
#

TRSHEL_DIR="$HOME/.trshell"


TRSHELL_DIST="$HOME/Borrar/tristan-scripts"
TRSHELL_LIBS="$HOME/Projects/eochoa-scripts"
TRSHELL_DIST="$HOME/Projects/eochoa-scripts"

TRSHELL_REMOTE_URL="git@github.com:tris-tran/tristan-scripts.git"
TRSHELL_REMOTE="origin"
TRSHELL_BRANCH="master"

source $TRSHELL_DIR/load.sh
load.full_init $TRSHELL_DIR

update-trshell.needs_update $TRSHELL_DIST
if [ $_r = true ]; then

    update-trshell.update $TRSHELL_DIST
    exec $0 $@
    exit 0
fi

LOG_LOGLEVEL="TRACE"

log.red "RED"
log.orange "ORANGE"
log.green "GREEN"

log.trace "Command to run is: [$@]"

${@}
