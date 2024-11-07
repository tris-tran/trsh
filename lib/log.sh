require log "
" || return 0

LOG_CONFIG_SHOW_TRACE=false

declare -g LOG_CURRENT_LEVEL=2

declare -g -A LOG_LEVEL
LOG_LEVEL["trace"]=4
LOG_LEVEL["debug"]=3
LOG_LEVEL["info"]=2
LOG_LEVEL["warn"]=1
LOG_LEVEL["error"]=0

LOG_ERROR="error"
LOG_WARN="warn"
LOG_INFO="info"
LOG_DEBUG="debug"
LOG_TRACE="trace"

LOG_RED=$(tput setaf 1)
LOG_GREEN=$(tput setaf 2)
LOG_ORANGE=$(tput setaf 3)
LOG_COLOR_RESET=$(tput sgr0)

function log.set_level() {
    LOG_CURRENT_LEVEL=${LOG_LEVEL["$1"]}
}

# Logs an empty line
function log.line() {
    echo ""
}

# Prints a string in red with echo
function log.red() {
    _log.color $LOG_RED $@
}

function log.orange() {
    _log.color $LOG_ORANGE $@
}

function log.green() {
    _log.color $LOG_GREEN $@
}

function _log.color() {
    local color=$1
    shift

    echo -n $color
    echo -e "$@"
    echo -n $LOG_COLOR_RESET
}

function log.warn() {
    _log.print_log $LOG_WARN $LOG_RED $@
}

function log.error() {
    _log.print_log $LOG_ERROR $LOG_RED $@
}

function log.info() {
    _log.print_log $LOG_INFO $LOG_GREEN $@
}

function log.debug() {
    _log.print_log $LOG_DEBUG $LOG_ORANGE $@
}

function log.trace() {
    _log.print_log $LOG_TRACE $LOG_ORANGE $@
}


_log__print_log_doc=$(cat <<-END
    Prints logs with echo, used internally
END
)
function _log.print_log() {
    local level=$1
    shift 
    local levelNumber=${LOG_LEVEL["$level"]}
    local color=$1
    shift 

    if [[ $levelNumber -gt $LOG_CURRENT_LEVEL ]]; then
        return
    fi

    local logLine=$color"$level :"
    if [ $LOG_CONFIG_SHOW_TRACE = true ]; then
        local funcPath="${FUNCNAME[@]:1}"
        logLine+=" [ $funcPath ] ${*}"
    else
        logLine+=" ${*}"
    fi
    logLine+=$LOG_COLOR_RESET

    echo $logLine >&2
}

