#!/bin/bash

TRSH_DIR="$HOME/.trshell"
TRSH_DIST="$HOME/.trshell"
TRSH_USER="$USER"
TRSHRC="$HOME/.trshrc"

TRSH_STORAGE="$TRSH_DIST/storage"

TRSH_STASH="$TRSH_DIR/storage/stash"
TRSH_STASH_REPO="stash"
TRSH_STASH_REMOTE="git@github.com:tris-tran/test-stash.git"
TRSH_STASH_BRANCH="master"
TRSH_STASH_GIT_REMOTE="origin"

LOG_LOGLEVEL="ERROR"

# Move to .trshrc
TRSH_DIR="/home/eochoa/Projects/eochoa-scripts"
TRSH_DIST="/home/eochoa/Projects/eochoa-scripts"
TRSH_USER="tochoa"
TRSH_STORAGE="$TRSH_DIST/storage"
TRSH_STASH="$TRSH_DIR/storage/stash"

[[ -f "$TRSHRC" ]] && source $TRSHRC
source $TRSH_DIR/internal/load.sh
load.base_init $TRSH_DIR
load.full_init $TRSH_DIR


trshell.init
trshell.update

env.config "stash.user" "eochoa"
env.get "stash.user"

install.configure_development

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
    stash-list
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
        source $@
    else
        popd > /dev/null
        log.red "Running with eval: $@"
        eval $@
    fi

    exit $?
}

function trsh.stash_list() {
    stash.list $@
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

