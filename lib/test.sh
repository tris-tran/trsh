
require test "
    log   
" || return 0

# Can tag a function (first line before declaration)
# to mark the function as a test ensures the function
# does not exists, and adds the function to tests to run.
declare -a TESTS
function @test() {
    local file=${BASH_SOURCE[1]}
    local annotationLine=${BASH_LINENO[0]}
    local line=$((annotationLine + 1))
    local annotated=$(
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

    TESTS+=($annotated)
}

function test.run_all() {
    for test in "${TESTS[@]}"
    do
        log.info "Running test $test"
        test.run_test "$test"
        if [[ "$?" != 0 ]]; then
            log.error "Failed $test"
        else
            log.info "Ok $test"
        fi
    done
}

# Runs a test in a subshell. Runs the tagged function
# inside a subshell to not pollute the env
function test.run_test() {(
    TRSH_TEST_DIR="$TRSH_TEST_DIR/$1"
    mkdir -p $TRSH_TEST_DIR

    cd $TRSH_TEST_DIR

    $1 

)}

function test.assert_return() {
    if [[ ! $? -eq 0 ]]; then
        exit 1
    fi
}

function test.assert_string() {
    local message="$1"
    local s1="$2"
    local s2="$3"

    if [[ "$s1" != "$s2" ]]; then
        _test.assert_fail "$message" "$s1" "$s2"
        exit 1
    fi
}

function _test.assert_fail() {
    local message="$1"
    local expected="$2"
    local actual="$3"
    
    log.error "Message: $message"
    log.error "Expected: "
    echo "$expected"
    log.error "Actual: "
    echo "$actual"
}

