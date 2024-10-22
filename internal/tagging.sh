require tagging "
    log
" || return 0

# You can deprecated a functionality to show log
# The idea is to call this function in the first 
# line of a deprecated function. So every time is
# called it shows deprecated log.
function @deprecated() {
    echo "${FUNCNAME[@]}" >&2
}
