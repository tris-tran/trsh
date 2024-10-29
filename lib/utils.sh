
require utils "
" || return 0



function utils.split_by() {
    local separator=$1
    local model=$2
    local currentSeparator=$IFS

    IFS=$separator
    read -ra _r <<< "$model"	
    IFS=$currentSeparator	
}

function utils.die() {
    local message=$1
    [ -z "$message" ] && message="Died"
    log.error "${BASH_SOURCE[1]}: line: ${BASH_LINENO[0]}: funcname:${FUNCNAME[1]} \"$message\""
    exit 1
}

function utils.error_and_exit() {
    if [ $? -ne 0 ]; then
        log.error $@
        exit 1
    fi
}

function utils.random() {
    local nchars=$1
    _r=$(tr -dc a-zA-Z0-9 < /dev/urandom | head -c $nchars )
}

function utils.random_num() {
    local nchars=$1
    _r=$(tr -dc 0-9 < /dev/urandom | head -c $nchars )
}

function utils.ensure_bash() {
   : 
}
