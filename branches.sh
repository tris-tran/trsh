#!/bin/bash
#
#Script para detectar ramas abiertas en los distintos proyectos
. ./log.sh
. ./hg.sh


function test() {

    log.trace "HELLO FROM TEST TRACE"
    log.debug "HELLO FROM TEST DEBUG"
    log.error "HELLO FROM TEST ERROR"
}

test

function utils.error_and_exit() {
    if [ $? -ne 0 ]; then
        log.error $@
        exit 1
    fi
}

LOG_LOGLEVEL="ERROR"

#hg.is_branch_active /home/eochoa/Projects/espublico-expedientes master-log-user-agent-login-task-63134
#echo $_r

#hg.is_branch_active /home/eochoa/Projects/espublico-expedientes master
#echo $_r

#hg.get_all_active_branches /home/eochoa/Projects/espublico-expedientes eochoa

hg.get_revision_from_project ssh://hg@hg-central.g3stiona.com/boe boe default

