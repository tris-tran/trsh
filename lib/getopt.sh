require getopt "
" || return 0


function getopts.getopts() {
    #local definitions
    #local args
    local shortOpts=""
    local longOpts=""

    function test.solve_key() {
        #local optionArgs
        local key=$1
        local realKey="${optionArgs[$key]}"
        if [[ ! -z "$realKey" ]]; then
            if [[ "$realKey" != "true" && "$realKey" != "?"  ]]; then
                test.solve_key "$realKey"
                _r="$_r"
                _r2="$_r2"
                return
            fi
        fi
        _r="$key"
        _r2="$realKey"
    }

    function _getopts.parse() {
        local parsedOpts=$(getopt -o $shortOpts --long $longOpts -- "$@")
        eval set -- "${parsedOpts}"
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
            options="$_r2"
            if [[ -z "$key" ]]; then
                echo "Error parsing option [$1]"; exit 1
            fi
            key="${key:2}"

            if [[ "$options" == "?" ]]; then
                args["$key"]=true
                continue
            fi

            value=$1
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
        read -r arguments longOpt shortOpt <<< "${definitions[$i]}"
        if [[ "$arguments" =~ ^[!]?[?]?$ ]]; then
            :
        else
            shortOpt="$longOpt"
            longOpt="$arguments"
            arguments=true
        fi

        optionArgs["--"$longOpt]="$arguments"
        longOpts+=",$longOpt"
        if [[ "$arguments" == "?" ]]; then
            :
        else
            longOpts+=":"
        fi
        if [[ ! -z "$shortOpt" ]]; then
            optionArgs["-"$shortOpt]="--$longOpt"
            shortOpts+="$shortOpt:"
        fi
    done

    longOpts="${longOpts:1}"
    longOpts="${longOpts::-1}"

    _getopts.parse "$@"
}
