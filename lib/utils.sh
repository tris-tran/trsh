
_load.load_once utils && return 0

function utils.split_by() {
    local separator=$1
    local model=$2
    local currentSeparator=$IFS

    IFS=$separator
    read -ra _r <<< "$model"	
    IFS=$currentSeparator	
}

function utils.error_and_exit() {
    if [ $? -ne 0 ]; then
        log.error $@
        exit 1
    fi
}
