#!/usr/bin/env trsh

require testa "
    getopt
" || return 0

SSHE_HOSTS[jonkins]="eedevadmin@192.168.5.200"
#echo "${SSHE_HOSTS[@]}"
#echo "${!SSHE_HOSTS[@]}"

function pepe() {
    @log "inside pepe"
}

shopt -s expand_aliases
alias lo="echo $@"

alias toStderr=">&2"
alias endusing=""

NAME="test"

TEST_OPTIONS=(
    run
    sample-op
)

_test_sample_op_doc=$(cat <<-END
    Sample of functionality
END
)
function test.sample_op() {
    local definitions=("user u" "branch b" "start_time s" "? isset" "? help" )
    local -A args
    getopts.getopts "$@"
    echo "Arguments $@"

    echo "options ${!args[@]}"
    echo "option user value:[${args[user]}]"
    echo "option branch value:[${args[branch]}]"
    echo "option start_time value:[${args[start_time]}]"
    echo "option isset value:[${args[isset]}]"
    echo "option help value:[${args[help]}]"

}

function test.run() {
:
}

cli.define_options "${TEST_OPTIONS[*]}"
cli.define_name "$NAME"
cli.run "$@"


