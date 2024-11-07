#!/usr/bin/bash
#
. trsh

require testa "
    getopt
" || return 0

if (exit 1) 2> /dev/null >&2; then


SSHE_HOSTS[jonkins]="eedevadmin@192.168.5.200"
#echo "${SSHE_HOSTS[@]}"
#echo "${!SSHE_HOSTS[@]}"

function pepe() {
    @log "inside pepe"
}

shopt -s expand_aliases
alias lo="echo $@"

alias endusing=""

function log() {
    tee >( while read line; do echo "[$1] $line"; done )
}

function die() {
    if [[ "$?" != 0 ]]; then
        echo "ERROR" >2&
    fi
}

function isset() {
    if [[ -z "$1" ]]; then
        return 1
    else
        return 0
    fi
}

function _set() {
    if isset "$1"; then 
        echo "$1"
    else
        echo ""
    fi
}

function _clean_r() {
    __r "" "" ""
}
function __r() {
    local array=("$@")

    _r="$(_set ${array[0]})"
    _r1="$(_set ${array[1]})"
    _r2="$(_set ${array[2]})"
}

alias ***='set -- $_r $_r1 $_r2'

function set_r() {
    _r="$@"
}


function bad() {
   __r "badpepe" "error1"
}

set -- "uno" "dos" "tres"
echo "$@"
_r2="other r"

bad ;***
echo "$1 $2 $3"

array=("uno" "dos")
set -- "$array"
echo "$@"

echo "$_r2"

if [[ -z "$_r" ]]; then
    echo "works"
fi

exit 1

else

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

fi
