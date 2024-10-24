#!/bin/env trsh


## TODO: improt all test files.
# all test files should be able to run independant
# once loaded each file can "executed" with test.run_all
# we need to clean "TESTS" env variable

TRSH_TEST_DIR="$TRSH_DIR/build/test"

@test
function test.dbawk.testread() {
pwd
    echo "test.dbawk.testread"
    test.assert_string 
}

test.run_all
