
. trsh

SSHE_HOSTS[jonkins]="eedevadmin@192.168.5.200"
#echo "${SSHE_HOSTS[@]}"
#echo "${!SSHE_HOSTS[@]}"

function pepe() {
    @log "inside pepe"
}



if [[ -z "$lib" ]]; then
    echo "NOT SET"
fi

shopt -s expand_aliases
alias lo="echo $@"

alias toStderr=">&2"
alias endusing=""

echo "pepe" toStderr

script_name=$(basename "$0")
short=u:b:s:
long=user:,branch:,start_time:,help

read -r -d '' usage <<EOF
Manually written help section here
EOF

TEMP=$(getopt -o $short --long $long --name "$script_name" -- "$@")

function test.getopts() {
    #local definitions
    #local args
    local shortOpts=""
    local longOpts=""

    function test.solve_key() {
        #local optionArgs
        local key=$1
        local realKey="${optionArgs[$key]}"
        echo "$key $realKey"
        if [[ ! -z "$realKey" ]]; then
            if [[ "$realKey" != "true" || "$realKey" == "<>" ]]; then
                test.solve_key "$realKey"
                realKey="$_r"
                _r="$realKey"
                return
            fi
        fi
        _r="$key"
    }

    function test.parse() {
        local parsedOpts=$(getopt -o $shortOpts --long $longOpts -- "$@")
        eval set -- "${parsedOpts}"
        echo "Parsing [$parsedOpts]"
        local key
        local value
        while :; do
            key=$1
            if [[ "$key" == "--" ]]; then
                break
            fi
            shift

            test.solve_key "$key"
            key="$_r"
            if [[ -z "$key" ]]; then
                echo "Error parsing option [$1]"; exit 1
            fi
            key="${key:2}"


            value=$1
            echo "Value $value key $key"
            if [[ "${value:0:2}" == "--" || -z "$value" ]]; then
                value="true"
            else
                shift
            fi
            args["$key"]="$value"
        done
    }

    declare -A optionArgs

    local longOpt
    local shortOpt
    local arguments
    for ((i = 0; i < ${#definitions[@]}; i++)); do
        read -r longOpt shortOpt arguments <<< "${definitions[$i]}"
        echo $arguments
        if [[ "$arguments" == "<>" ]]; then
            :
        else
            arguments=true
        fi
        optionArgs["--"$longOpt]="$arguments"
        longOpts+=",$longOpt:"
        if [[ ! -z "$shortOpt" ]]; then
            optionArgs["-"$shortOpt]="--$longOpt"
            shortOpts+="$shortOpt:"
        fi
    done

    longOpts="${longOpts:1}"
    longOpts="${longOpts::-1}"

    echo "long[$longOpts]short[$shortOpts]"
    test.parse "$@"
}

function void() {
:
}

alias getopts="
    local -A args
    echo "parsing[$@]"
    test.getopts "$@"
    void 
"

function real_func() {
    local definitions=("user u <>" "branch b <>" "start_time s <>" "isset" "help" )
    getopts "$definitions"


    echo "options ${!args[@]}"
    echo "option user value:[${args[user]}]"
    echo "option branch value:[${args[branch]}]"
    echo "option start_time value:[${args[start_time]}]"
    echo "option isset value:[${args[isset]}]"
}

echo "opter parsing["$@"]"
real_func "$@"

exit 1


echo "GETOPS: [$TEMP]"

function test.parse() {
    local parsedOpts=$(getopt -o $short --long $long  -- "$@")
    eval set -- "${parsedOpts}"
    echo "$1, $2, $3"
    while :; do
        case "${1}" in
            -u | --user       ) user=$2;             shift 2 ;;
            -b | --branch     ) branch=$2;           shift 2 ;;
            -s | --start_time ) start_time=$2;       shift 2 ;;
            --help            ) echo "${usage}" 1>&2;   exit ;;
            --                ) shift;                 break ;;
            *                 ) echo "Error parsing option [$1]"; exit 1 ;;
        esac
    done
}

test.parse "$@"

exit 1

#!/bin/env trsh

TEST_OPTIONS=(
    run
    sample-op
)

_TEST_sample_op_DOC=$(cat <<-END
    Sample of functionality
END
)
function test.sample_op() {
    local args=$@
    echo "Arguments $@"
}

function test.run() {
:
}

cli.define_options "${TEST_OPTIONS[*]}"
cli.define_name "TEST"
#cli.run $@


