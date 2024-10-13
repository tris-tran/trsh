#!/bin/bash
#

TRSH_DIR="$HOME/.trshell"
TRSH_DIR="/home/tristanstille/Projects/tristan-scripts"

TRSH_STASH="/home/tristanstille/Borrar/test-stash"
TRSH_USER="tochoa"

TRSH_DIST="$HOME/Borrar/tristan-scripts"
TRSH_LIBS="$HOME/Projects/eochoa-scripts"
#TRSH_DIST="$HOME/Projects/eochoa-scripts"
#



TRSH_REMOTE_URL="git@github.com:tris-tran/tristan-scripts.git"
TRSH_REMOTE="origin"
TRSH_BRANCH="master"

LOG_LOGLEVEL="TRACE"

source $TRSH_DIR/internal/load.sh
load.base_init $TRSH_DIR
load.full_init $TRSH_DIR

trshell.init
trshell.update

log.trace "Command to run is: [$@]"
(return 0 2>/dev/null)
if [ $? -eq 0 ]; then
    log.green "Loading without script"
    return 0
fi

TRSH_OPTIONS=(
    run
    package

    create

    stash-script
    stash-function
    stash-oneliner
)

function trsh.create() {
    local scriptName=$1
    local userName=$1
    userName=${userName/-/_}
    function _template() {
        export NAME=${userName^^}
        export uNAME=${userName,,}

        template.apply "script" "${scriptName,,}.sh"
    }
    _template&
}

_TRSH_run_DOC=$(cat <<-END
    Executes the programm from command line
    once the trsh is loaded
END
)
function trsh.run() {
    local command=$1

    pushd / > /dev/null
    if ! command -v $command 2>&1 > /dev/null; then
        popd > /dev/null
        log.red "Running with bash: $@"
        bash $@
    else
        popd > /dev/null
        log.red "Running with eval: $@"
        eval $@
    fi

    exit $?
}

function trsh.stash_script() {
    stash.script $@
}

function trsh.stash_function() {
    stash.function $@
}

function trsh.stash_oneliner() {
    stash.script $@
}

cli.define_options "${TRSH_OPTIONS[*]}"
cli.define_name "TRSH"

if [ -f "$1" ]; then
    ${@}
    exit $?
else
    cli.run $@
fi

