#!/usr/bin/bash
#
. trsh

require testa "
    getopt
" || return 0

if (exit 0) 2> /dev/null >&2; then

function sload() {
    set +a
    . ./stest.sh
    echo $name
    set -a
}

sload

echo $name
exit 1


SSHE_HOSTS[jonkins]="eedevadmin@192.168.5.200"
#echo "${SSHE_HOSTS[@]}"
#echo "${!SSHE_HOSTS[@]}"

function pepe() {
    @log "inside pepe"
}

declare -A a
a[local]="localpar"
a[remote]="remote"

declare -p a

function print_array() {
    local -n arr_ref=$1

    for key in ${!arr_ref[@]}
    do
        echo "[$key]=${arr_ref[$key]}"
    done
}

print_array a
exit 1

sand="ASPOSE|cb70b650e76999556e9565a68214d0b7ee6b95f9|git|git@git-central.g3stiona.com:aspose.git|Y"

IFS='|'
asdf=($sand)

function p.toLow() {
    echo ${1,,}
}

a="p"
$a.toLow ${asdf[0]}

echo ${asdf[0]}



function aar() {
    local -n p=$1

    echo ${p[name]}
    echo ${p[repoType]}
}
aar signerServerStub

exit 1

shopt -s expand_aliases
alias endusing=""


exit 1

set -a
function localvar() {
    local pepe="localpepe"
}
localvar
set +a

echo $pepe


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
