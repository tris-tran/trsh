_load.load_once log && return 0

#LOG_LOGLEVEL="TRACE"
LOG_CONFIG_SHOW_TRACE=false

LOG_ERROR_LOGLEVEL="ERROR"
LOG_INFO_LOGLEVEL="INFO"
LOG_DEBUG_LOGLEVEL="DEBUG"
LOG_TRACE_LOGLEVEL="TRACE"

LOG_RED=$(tput setaf 1)
LOG_GREEN=$(tput setaf 2)
LOG_ORANGE=$(tput setaf 3)
LOG_COLOR_RESET=$(tput sgr0)


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


function log.error() {
    _log.print_log $LOG_ERROR_LOGLEVEL $@
}

function log.info() {
    _log.print_log $LOG_INFO_LOGLEVEL $@
}

function log.debug() {
    if [ "$LOG_DEBUG_LOGLEVEL" = "$LOG_LOGLEVEL" -o "$LOG_TRACE_LOGLEVEL" = "$LOG_LOGLEVEL" ]; then
        _log.print_log $LOG_DEBUG_LOGLEVEL $@
    fi
}

function log.trace() {
    if [ "$LOG_TRACE_LOGLEVEL" = "$LOG_LOGLEVEL" ]; then
        _log.print_log $LOG_TRACE_LOGLEVEL $@
    fi
}


_LOG__print_log_DOC=$(cat <<-END
    Prints logs with echo, used internally
END
)
function _log.print_log() {
    local funcPath="${FUNCNAME[@]:1}"
    local level=$1
    echo -n $LOG_GREEN
    if [ $LOG_CONFIG_SHOW_TRACE = true ]; then
        echo "$level" ": [" "$funcPath" "] \"${*:2}\"" $LOG_COLOR_RESET
    else
        echo "$level" ": \"${*:2}\"" $LOG_COLOR_RESET
    fi
}

