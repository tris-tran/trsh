_load.load_once cli && return 0

TRSH_CURRENT_OPTIONS=
TRSH_CURRENT_NAME=

function cli.define_name() {
    local name=$1
    TRSH_CURRENT_NAME=$name
}

function cli.define_options() {
    TRSH_CURRENT_OPTIONS=($@)
}

function cli.help() {
    if [ -z $TRSH_CURRENT_OPTIONS ]; then
        log.error "No options defined."
    fi

    for opt in "${TRSH_CURRENT_OPTIONS[@]}"
    do
        if [[ "$opt" != "help" ]]; then
            eval "local doc=\"\$_${TRSH_CURRENT_NAME}_${opt/-/_}_DOC\""
            echo $opt
            echo "$doc"
        fi
    done
}

function cli.run() {
    local option=$1
    shift
    local function=$TRSH_CURRENT_NAME"."$option
    function=${function/-/_}
    function=${function,,}

    if [ -z "${TRSH_CURRENT_OPTIONS}" ]; then
        cli.help
        return 1
    fi

    if [[ "${TRSH_CURRENT_OPTIONS[*]}" =~ "$option" ]]; then
        if [[ "$(type -t $function)" = "function" ]]; then
            $function $@
            return 0
        fi
    fi

    cli.help $@
}
