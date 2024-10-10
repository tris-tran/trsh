#!/bin/bash
#
#


TRSHELL_DIST="/home/tristanstille/Borrar/tristan-scripts"

TRSHELL_LIBS="/home/tristanstille/Projects/tristan-scripts"
source $TRSHELL_LIBS/load.sh
load.full_init $TRSHELL_LIBS

update-trshell.update $TRSHELL_DIST


LOG_LOGLEVEL="TRACE"

log.red "RED"
log.orange "ORANGE"
log.green "GREEN"

log.trace "Command to run is: [$@]"

load.import asdf
${@}
