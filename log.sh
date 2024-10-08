LOG_LOGLEVEL="TRACE"

LOG_ERROR_LOGLEVEL="ERROR"
LOG_INFO_LOGLEVEL="INFO"
LOG_DEBUG_LOGLEVEL="DEBUG"
LOG_TRACE_LOGLEVEL="TRACE"

LOG_RED=$(tput setaf 1)
LOG_GREEN=$(tput setaf 2)
LOG_ORANGE=$(tput setaf 3)
LOG_RESET=$(tput sgr0)


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

function _log.print_log() {
    local funcPath="${FUNCNAME[@]:1}"
    echo -n $LOG_ORANGE
    echo "$1" ": [" "$funcPath" "] \"${*:2}\"" $LOG_RESET
}

