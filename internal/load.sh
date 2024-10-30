
TRSH_LIB_PATH="$TRSH_DIR/internal:$TRSH_DIR/lib"

# Array with loaded libs to prevent multiple loads of one library
# in the same script
declare -g -A _LIB_LOADED

#deprecated
declare -r _LOAD_INTERNALS=()

#List of possible libraries
#deprecated
declare -r _LOAD_LIBS=()

declare -g -a chain
function require() {
    local lib=$1
    local imports=$2

    _load.is_loaded $lib && return 0

    if [ -z "$chain" ]; then
        chain=( $lib )
    else
        for chained in "${chain[@]}"
        do
            if [[ "$lib" == "$chained" ]]; then
                echo "Circular dependecy detected for lib $lib chain [${chain[@]}]"
                echo "${FUNCNAME[@]}"
                exit 1
            fi
        done
        chain=( ${chain[@]} $lib )
    fi

    for import in ${imports[@]}
    do
        _load.is_loaded $import && continue
        _load.source_lib $import
    done

    unset chain[$(( ${#chain[@]} - 1 ))]
}


function load.import() {
    @deprecated

    local lib=$1

    if [ -z "$chain" ]; then
        chain=( $lib )
    else
        for chained in "${chain[@]}"
        do
            if [[ "$lib" == "$chained" ]]; then
                echo "Circular dependecy detected for lib $lib chain [${chain[@]}]"
                exit 1
            fi
        done

        chain=( $chain $lib )
    fi

    _load.source_lib $lib 
    local r=$?

    unset chain[${#chain[@]}-1]
    return $r
}

function load.base_init() {
    @deprecated

    _load.libs "${_LOAD_INTERNALS[@]}"
}

function load.full_init() {
    @deprecated

    load.base_init 
    _load.libs "${_LOAD_LIBS[@]}"
}

function _load.libs() {
    local libs=($@) 
    for lib in ${libs[@]}
    do
        _load.source_lib $lib
    done

}
function _load.source_lib() {
    local lib=$1

    local libFile=$(_load.search_lib $lib)
    if [[ -z "$libFile" ]]; then
        echo "${FUNCNAME[@]}"
        echo "No file lib found for ${lib}.sh in $libPath"
        exit 1
    fi

    #source
    . $libFile
    _load.import_error $libFile
    _load.load_once $lib
}

function _load.import_error() {
    if [ $? -ne 0 ]; then
        echo "Error loading library $1"
        exit 1
    fi
}

function _load.load_once() {
    local lib=$1

    _load.is_loaded $lib && return 0
    _LIB_LOADED[$lib]=true
    
    return 1
}

function _load.is_loaded() {
    local lib=$1
    [[ "${_LIB_LOADED[$lib]}" = "true" ]] && return 0
    return 1
}

function _load.random() {
    local nchars=$1
    _r=$(tr -dc a-zA-Z0-9 < /dev/urandom | head -c $nchars )
}

function @deprecated() {
:
}

function _load.search_lib() {
    local lib=$1
    local IFS=":"
    local possibleNames=$(echo $lib{.sh,.trsh})
    for libPath in $TRSH_LIB_PATH
    do
        IFS=" "
        for libName in $possibleNames
        do
            libFile="$libPath/$libName"
            if [[ -f "$libFile" ]]; then
                echo $libFile
                return 0
            fi
        done
    done
    return 1
}
