#!/usr/bin/env trsh

SCRIPT=$1
SCRIPT_FILE=$(basename $SCRIPT)
SCRIPT_NAME=${SCRIPT_FILE%.*}
SCRIPT_OUT="$TRSH_DIST/bin/$SCRIPT_NAME"

function package.main() { {
    echo "#!/bin/bash"
    if [[ "$SCRIPT_NAME" != "trsh" && "$SCRIPT_NAME" != "trshell" ]]; then
        echo "_TRSH_LOADED=true"
    fi
    echo "_TRSH_PACKAGED=true"
    echo "(return 0 2>/dev/null)
    if [ \$? -eq 0 ]; then
        log.trace \"Loading without script\"
        _TRSH_SOURCED=true
    fi"
    echo "function ___PACKAGED_SCRIPT() {" 
    echo "echo running \$@"
    #script to package
    cat $SCRIPT
    echo "}" 

    #Package library
    echo "function ___PACKAGED_TRSH() {"
    load.package "$TRSH_DIST"
    echo "}" 

    #Delcare load and running
    echo "___PACKAGED_TRSH" 
    echo "___PACKAGED_SCRIPT \$@" 

} > $SCRIPT_OUT; }

function load.package() {(
    loadFrom=$1

    _LIB_LOADED=( )

    allLibs=( ${_LOAD_INTERNALS[@]} ${_LOAD_LIBS[@]} )

    echo "declare -A _LIB_LOADED"

    for lib in ${allLibs[@]}
    do
        _load.load_once "$lib"

        internalLibPath="$loadFrom/internal/${lib}.sh"
        normallibPath="$loadFrom/lib/${lib}.sh"

        echo "function lib.$lib() {"

        if [ -f "$internalLibPath" ]; then
            awk NF $internalLibPath
        elif [ -f "$normallibPath" ]; then
            awk NF $normallibPath
        else
            exit 1
        fi

        echo "}"
    done

    declare -f _load.load_once
    declare -f load.import

    echo "function _load.source_lib() {
        lib.\$1
    }"

    #TODO: Delete once all the imports are correctly place in library
    for lib in ${allLibs[@]}
    do
        echo "load.import $lib"
    done

    ); return $?
}

package.main
