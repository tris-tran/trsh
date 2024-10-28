_load.load_once db && return 0

DB_ERRNO_DUP=2
DB_ERRNO_NO_KEY=3

function awkdb.delete_db() {
    local folder=$1
    local dbName=$2
    local db="$folder/$dbName"
    pushd $folder > /dev/null
    rm "$db"
    _r="$db"
    popd > /dev/null

}

function awkdb.list() {
    local db=$1
    _r=$(awk -v key=$key -v field=$field '
        BEGIN { FS="|"; OFS="|" }
        { print $1 } 
        ' $db)
}

function awkdb.create_db() {
    local folder=$1
    local dbName=$2
    local db="$folder/$dbName"
    mkdir -p $folder
    pushd $folder > /dev/null
    touch "$db"
    _r="$db"
    popd > /dev/null
}

function awkdb.delete() {
    local db=$1
    local key=$2

    _awkdb.update
    local trans=$_r

    awk -v key=$key '
        BEGIN { FS="|"; OFS="|" }
        $1 == key { next }
        { print }
        ' $db > $trans

    _awkdb.commit $db $trans
}

function awkdb.get() {
    local db=$1
    local key=$2
    local field=$(($3 + 1))

    _r=$(awk -v key=$key -v field=$field '
        BEGIN { FS="|"; OFS="|" }
        $1 == key { $1=""; print $field; exit 0; }
        END { exit 3 }
        ' $db)
    return $?
}

function awkdb.get_raw() {
    local db=$1
    local key=$2

    _r=$(awk -v key=$key '
        BEGIN { FS="|"; OFS="|" }
        $1 == key { $1=""; print substr($0, 2); exit 0; }
        END { exit 3 }
        ' $db)
    return $?
}

function awkdb.get_from_raw() {
    local field=$1
    local raw=$2
    _r=$(echo "$raw" | awk -v field=$field '
        BEGIN { FS="|"; OFS="|" }
        { print $field }
        ')
    return $?
}

function awkdb.put() {
    local db=$1
    local key=$2
    local field=$(($3 + 1))
    local value=$4

    _awkdb.update
    local trans=$_r

    awk -v key=$key -v field=$field -v value=$value '
        BEGIN { FS="|"; OFS="|" }
        $1 ~ key { found = 1; $field=value; print $0; next }
        { print }
        END { if ( ! found) { $0=""; $field=value; $1=key; print $0 } }
        ' $db > $trans

    _awkdb.commit $db $trans
}

function _awkdb.update() {
    _r=$(mktemp)
}

function _awkdb.commit() {
    local db=$1
    local tempDb=$2
    mv $2 $1
}
