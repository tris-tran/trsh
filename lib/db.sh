_load.load_once db && return 0

DB_ERRNO_DUP=2
DB_ERRNO_NO_KEY=3

function db.mapper() {
    local nFields=$1
    shift

    local keys=()
    for (( i=1; i<=$nFields; i+=1 ))
    do
        eval `istSet="\\${${!i}+x}"`
        # Substite this for -v vlidation of variable
        # probably on an eval statment
        if [[ -z "$isSet" ]]; then
            echo "variable ${!i} not set"
        fi
        keys=( ${keys[@]} ${!i} )
    done
    shift $nFields 
    for (( i=1; i<=$nFields; i+=1 ))
    do
        key=${keys[$(( $i - 1 ))]}
        printf -v "$key" '%s' "${!i}"
    done
}

function db.validate() {
    local db=$1

    local duplicateKey=$(awk '
        BEGIN { FS="|"; OFS=" " }
        keys[$1]++ { $1=$1; print "duplicate", NR, $0; exit 2; }
        END { exit 0 }
        ' $db)

    if [[ "$?" != 0 ]]; then
        _r=$duplicateKey
        return 1
    fi
}

function db.get_key() {
    local db=$1
    local key=$2
    _r=$(awk -v key=$key '
        BEGIN { FS="|"; OFS=" " }
        $1 == key { $1=""; print $0; exit 0; }
        END { exit 3 }
        ' $db)
    return $?
}

function db.set_value() {
    local db=$1
    local key=$2
    local field=$3
    local value=$4

    _db.update
    local trans=$_r

    awk -v key=$key -v field=$field -v value=$value '
        BEGIN { FS="|"; OFS="|" }
        $1 ~ key { $field=value; print $0; next }
        { print }
        ' $db > $trans

    _db.commit $db $trans
}

function db.put_value() {
    local db=$1
    shift
    local key=$1
    shift

    local row="$key"
    for field in "$@"
    do
        row="$row|$field"
    done

    _db.update
    local trans=$_r
     awk -v key=$key -v row="$row" '
        BEGIN { FS="|" }
        $1 == key { printed=1; print row; next }
        { print }
        END { if (!printed) { print row } }
    ' $db 

    _db.commit $db $trans
}

function _db.update() {
    _r=$(mktemp)
}

function _db.commit() {
    local db=$1
    local tempDb=$2
    mv $2 $1
}
