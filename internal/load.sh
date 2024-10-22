
# Array with loaded libs to prevent multiple loads of one library
# in the same script
declare -A _LIB_LOADED

declare -r _LOAD_INTERNALS=(
    colors
    log
    env
    trshell
    stash
    update-trshell
    install
    doc
)

#List of possible libraries
declare -r _LOAD_LIBS=(
    utils
    db
    trap
    cli
    template
    hg
    git
    vcs
)

function require() {
    local lib=$1
    local imports=$2

    echo "$lib"

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

    _load.load_once $lib && return 1

    for import in ${imports[@]}
    do
        _load.source_lib $lib || exit 1
    done

    unset chain[${#chain[@]}-1]
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

    local libPath="$TRSH_DIR"
    local libFile="$libPath/lib/${lib}.sh"

    if [ ! -f "$libFile" ]; then 
        libFile="$libPath/internal/${lib}.sh"
        if [ ! -f "$libFile" ]; then
            echo "${FUNCNAME[@]}"
            echo "No file lib found for ${lib}.sh in $libPath"
            exit 1
        fi
    fi

    #source
    . $libFile
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

function _load.random() {
    local nchars=$1
    _r=$(tr -dc a-zA-Z0-9 < /dev/urandom | head -c $nchars )
}


