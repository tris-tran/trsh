

#TRSHELL_LIBS exists at this point

# Array with loaded libs to prevent multiple loads of one library
# in the same script
declare -A _LIB_LOADED

#List of possible libraries
declare -r _LOAD_LIBS=(
    log
    utils
    hg
    git

    # Internal libs
    update-trshell
)

function load.import() {
    local lib=$1
    _load.source_lib $TRSHELL_LIBS  $lib
}

function load.full_init() {
    local libPath=$1
    for lib in ${_LOAD_LIBS[@]}
    do
        _load.source_lib $libPath $lib
    done
    
}

function _load.source_lib() {
    local libPath=$1
    local lib=$2

    #source
    . $libPath/lib/$lib".sh"
    _load.import_error $libPath $lib

    _load.load_once $lib
}

function _load.import_error() {
    if [ $? -ne 0 ]; then
        echo "Error loading library $2 from $1"
        exit 1
    fi
}


function _load.load_once() {
    local lib=$1

    [[ "${_LIB_LOADED[$lib]}" = "true" ]] && return 0
    _LIB_LOADED[$lib]=true
    
    return 1
}
