_load.load_once env && return 0

declare -g -A TRSHENV

function env.config() {
    local key=$1
    local value=$2

    TRSHENV["$key"]=$value
}

function env.get() {
    local key=$1

    _r=${TRSHENV["$key"]}
}
