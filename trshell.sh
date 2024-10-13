#!/bin/bash
#

TRSH_DIR="$HOME/.trshell"
TRSH_DIR="/home/tristanstille/Projects/tristan-scripts"

TRSH_STASH="/home/tristanstille/Borrar/test-stash"
TRSH_USER="tochoa"

TRSH_DIST="$HOME/Borrar/tristan-scripts"
TRSH_LIBS="$HOME/Projects/eochoa-scripts"
TRSH_DIST="$HOME/Projects/eochoa-scripts"

TRSH_REMOTE_URL="git@github.com:tris-tran/tristan-scripts.git"
TRSH_REMOTE="origin"
TRSH_BRANCH="master"

source $TRSH_DIR/load.sh
load.base_init $TRSH_DIR
load.full_init $TRSH_DIR

return 0
update-trshell.needs_update $TRSH_DIST
if [ $_r = true ]; then

    update-trshell.update $TRSH_DIST
    exec $0 $@
    exit 0
fi

LOG_LOGLEVEL="TRACE"

log.red "RED"
log.orange "ORANGE"
log.green "GREEN"

log.trace "Command to run is: [$@]"

if [ $# -eq 0 ]; then
    log.green "Loading without script"
else        
    ${@}
fi
