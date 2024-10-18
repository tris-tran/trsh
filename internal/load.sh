
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
)

#List of possible libraries
declare -r _LOAD_LIBS=(
    utils
    trap
    cli
    template
    hg
    git
    vcs
)

function load.package() {(
    loadFrom=$1

    _LIB_LOADED=( )

    allLibs=( ${_LOAD_INTERNALS[@]} ${_LOAD_LIBS[@]} )

    for lib in ${allLibs[@]}
    do
        _load.load_once "$lib"

        internalLibPath="$loadFrom/internal/${lib}.sh"
        normallibPath="$loadFrom/lib/${lib}.sh"

        echo "function lib.$lib() {"
        echo "set -a"
        if [ -f "$internalLibPath" ]; then
            cat $internalLibPath
        elif [ -f "$normallibPath" ]; then
            cat $normallibPath
        else
            exit 1
        fi
        echo "set +a"
        echo "}"

    done

    declare -f _load.load_once

    echo "function load.import() {
        "lib.\$lib"
    }"

    for lib in ${allLibs[@]}
    do
        echo "lib.$lib"
    done
    ); return $?
}

function load.import() {
    local lib=$1
    _load.source_lib "$TRSH_DIR/lib" $lib
}

function load.base_init() {
    local libPath=$1
    _load.libs $libPath "${_LOAD_INTERNALS[*]}"
}

function load.full_init() {
    local libPath=$1
    load.base_init $libPath
    _load.libs $libPath "${_LOAD_LIBS[*]}"
}

function _load.libs() {
    local libPath=$1
    shift
    local libs=($@) 
    for lib in ${libs[@]}
    do
        _load.source_lib $libPath $lib
    done

}
function _load.source_lib() {
    local libPath=$1
    local lib=$2

    local libFile="$libPath/lib/${lib}.sh"

    if [ ! -f "$libFile" ]; then 
        libFile="$libPath/internal/${lib}.sh"
        if [ ! -f "$libFile" ]; then
            echo "No file lib found for ${lib}.sh"
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
