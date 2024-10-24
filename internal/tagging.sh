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

# Can tag a function (first line before declaration)
# to mark the function as a test ensures the function
# does not exists, and adds the function to tests to run.
declare -a TESTS
function @test() {
    local file=${BASH_SOURCE[1]}
    local annotationLine=${BASH_LINENO[0]}
    local line=$((annotationLine + 1))
    local annotated=$(
        $AWK -v "n=$line" '
        BEGIN { FS=" |\(\)" } 
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

    TESTS+=($annotated)
}


