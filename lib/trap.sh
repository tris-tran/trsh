_load.load_once trap && return 0

declare -g -r _TRAP_EXIT_FUNC

function _trap.on_exit() {
    for traps in "${_TRAP_EXIT_FUNC[@]}"
    do
        log.trace "Running exit trap $traps"
        $traps
    done
}

trap _trap.on_exit EXIT


function trap.exit() {
    local function=$1
    _trap.on_exit "$function"
}


function _trap.add_exit() {
    local function=$1
    _TRSH_EXIT_FUNC+=("$function")
}


