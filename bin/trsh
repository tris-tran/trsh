#!/bin/bash

#If the enviroment is already loaded, we do not load twice
if [[ ! -z "$_TRSH_LOADED" ]]; then
    return 0
fi
_TRSH_LOADED=true

TRSH_DIR="$HOME/.trshell"
TRSH_DIST="$HOME/.trshell"
TRSH_USER="$USER"
TRSHRC="$HOME/.trshrc"
TRSH_BIN="$TRSH_DIST/bin"

TRSH_STORAGE="$TRSH_DIST/storage"

TRSH_STASH="$TRSH_DIR/storage/stash"
TRSH_STASH_REPO="stash"
TRSH_STASH_REMOTE="git@github.com:tris-tran/test-stash.git"
TRSH_STASH_BRANCH="master"
TRSH_STASH_GIT_REMOTE="origin"

LOG_LOGLEVEL="ERROR"

# Move to .trshrc
TRSH_STASH_REMOTE="$HOME/Projects/MIERDA/stash-gestiona"
TRSH_DIR="$HOME/Projects/trsh"
TRSH_DIST="$HOME/Projects/trsh"
TRSH_USER="tochoa"
TRSH_STORAGE="$TRSH_DIST/storage"
TRSH_STASH="$TRSH_DIR/storage/stash"
TRSH_BIN="$TRSH_DIST/bin"
LOG_LOGLEVEL="ERROR"

export PATH="$PATH:$TRSH_BIN"

TRSH_SCRIPT_LUNCH_PWD="$PWD"
function _trsh.cleanup() {
    if [ "$PWD" != "$TRSH_SCRIPT_LUNCH_PWD" ]; then
        cd "$TRSH_SCRIPT_LUNCH_PWD"
    fi
}

[[ -f "$TRSHRC" ]] && source $TRSHRC
source $TRSH_DIR/internal/load.sh

#This perevents sourcing the script twice
require trsh "
    tagging
    colors
    log
    env
    test
    trshell
    stash
    update-trshell
    install
    doc
    utils
    awkdb
    trap
    cli
    getopt
    template
    hg
    git
    vcs
" || exit 1

trshell.init
#trshell.update

install.configure_development

echo "$@"
# If its not a packaged version of the script
# we can check if its being sourced right here
log.trace "Command to run is: [$@]"
(return 0 2>/dev/null)
if [ $? -eq 0 ]; then
    _TRSH_SOURCED=true
    log.trace "Loading without script"
    return 0
fi

#TODO: remove all this.

TRSH_OPTIONS=(
    run
    package

    create

    stash-script
    stash-function
    stash-oneliner
    stash-list
    stash-install
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
        log.trace "Running with bash: $@"
        BASH_ARGV0=$1
        shift
        source $0 $@
    else
        popd > /dev/null
        log.trace "Running with eval: $@"
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

function trsh.stash_install() {
    stash.install_script $@
}

cli.define_options "${TRSH_OPTIONS[*]}"
cli.define_name "TRSH"

if [ -f "$1" ]; then
    BASH_ARGV0=$1
    shift
    source $0 "$@"
    exit $?
else
    cli.run $@
fi

