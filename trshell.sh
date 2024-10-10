#!/bin/bash
#
#



TRSHELL_DIST="/home/tristanstille/Borrar/tristan-scripts"
TRSHELL_LIBS="/home/tristanstille/Projects/tristan-scripts"

TRSHELL_REMOTE=""
TRSHELL_BRANCH=""

source $TRSHELL_LIBS/load.sh
load.full_init $TRSHELL_LIBS

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
