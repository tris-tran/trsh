require tagging "
" || return 0

# You can deprecated a functionality to show log
# The idea is to call this function in the first 
# line of a deprecated function. So every time is
# called it shows deprecated log.
# Also shows all the stack trace of the call
function @deprecated() {
    @warning "@deprecated ${FUNCNAME[1]}"
}

# Prints a warning with all the stack trace of the call
function @warning() {
    echo "Warning $@" >&2
    @print_trace >&2
}

# Prints a dugging log (instead of echo)
# and shows the line and file of the source
# usefull when debugin and later to delete all
# logs
function @log() {
    @print_trace_source >&2
    echo "@log:: $@" >&2
}

# Prints (without new line) the source of a call
# with one level of indirection @see @log
function @print_trace_source() {
    local funcCount=${#FUNCNAME[@]}
    local i=$(( $funcCount - 1 )) 
    local j=$(( $i - 1 ))
    echo -n "[${BASH_SOURCE[$i]}:${BASH_LINENO[$j]}:${FUNCNAME[$j]}]"
}

# Prints the trace of the call, all the files
# functions and line numbrers
function @print_trace() {
    local funcCount=${#FUNCNAME[@]}
    for (( i=2; i<funcCount; i++ ));
    do
        local j=$(( $i - 1 ))
        echo "[${BASH_SOURCE[$i]}:${BASH_LINENO[$j]}:${FUNCNAME[$j]}]"
    done
}

# Sample for a tag of a function that get
# the function declaration
function @function() {
    _tagging.get_function
    local function="$_r"
    @log $function
}

# Obtains with one level of indirection the
# tagged function
function _tagging.get_function() {
    local file=${BASH_SOURCE[2]}
    local annotationLine=${BASH_LINENO[1]}
    local line=$((annotationLine + 1))
    _r=$(
        awk -v "n=$line" '
        BEGIN { FS=" |\\(\\)" } 
        NR == n { 
            if ( $1 == "function" ) {
                print $2
                exit 0
            } else {
                exit 1
            }
        }
        ' "$file" || { 
            echo "Error annotation @test bad: $file:$annotationLine"
            exit 1
        }
    ) 
}

