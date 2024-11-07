#!/bin/env trsh


## TODO: improt all test files.
# all test files should be able to run independant
# once loaded each file can "executed" with test.run_all
# we need to clean "TESTS" env variable

TRSH_TEST_DIR="$TRSH_DIR/build/test"

@test
function test.log.test() {
    LOG_CURRENT_LEVEL=-1
    log.error "ERROR"
    log.warn "WARN"
    log.info "INFO"
    log.debug "DEGUG"
    log.trace "TRACE"
}

@test
function test.doc.document_all() {
    doc.document_trsh
}

@test
function test.dbawk.testput() {
    local db

    awkdb.delete_db $TRSH_TEST_DIR "testDb.awkdb"
    awkdb.create_db $TRSH_TEST_DIR "testDb.awkdb"
    db=$_r

    awkdb.put $db "keydelete" 1 "field1"
    test.assert_return

    awkdb.delete $db "keydelete" 
    test.assert_return

    awkdb.put $db "key1" 1 "field1"
    test.assert_return

    awkdb.put $db "key1" 1 "field2"
    test.assert_return

    awkdb.put $db "key1" 4 "field4"
    test.assert_return

    awkdb.put $db "key2" 1 "field1"
    test.assert_return

    awkdb.put $db "key2" 2 "field2"
    test.assert_return

    awkdb.put $db "key9" 4 "field4"
    test.assert_return

    local currentDb=$(cat $db)
    local expectedDb=$(cat << END
key1|field2|||field4
key2|field1|field2
key9||||field4
END
)
    test.assert_string "Db" "$expectedDb" "$currentDb"

    awkdb.get $db "key1" 1
    test.assert_string "key1 field 1" "field2" "$_r"

    awkdb.get $db "key1" 3
    test.assert_string "key1 field 3" "" "$_r"

    awkdb.get $db "key2" 1
    test.assert_string "key2 field 1" "field1" "$_r"

    awkdb.get $db "key9" 1
    test.assert_string "key9 field 1" "" "$_r"

    awkdb.get $db "key9" 4
    test.assert_string "key9 field 4" "field4" "$_r"

    awkdb.get_raw $db "key9"
    test.assert_string "key9 get_raw" "|||field4" "$_r"

    local raw="$_r"
    awkdb.get_from_raw 4 "$raw"
    test.assert_string "key9 field 4" "field4" "$_r"

    awkdb.get_from_raw 1 "$raw"
    test.assert_string "key9 field 1" "" "$_r"
}

test.run_all
