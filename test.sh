#!/bin/bash
#

declare -r pepe="adssd"
pepe="pepe"

TRSHELL_SUPPORTED_OPTIONS=(
    help
    package
    install
    sysinstall

    # Ensure and try to configure all the env
    configure
    # Info about the local env
    info
    )

function test.help() {
    for opt in "${TRSHELL_SUPPORTED_OPTIONS[@]}"
    do
        if [[ "$opt" != "help" ]]; then
            eval "local doc=\"\$_TEST_${opt}_DOC\""
            echo $opt
            echo "$doc"
        fi
    done
}

_TEST_package_DOC=$(cat <<-END
    Package the complete app
    asdasd asdsad esto es nueva linea
END
) 
function test.package() {
    echo "test.package"
}

function main() {
    local option=$1
    local function="test.$option"


    if [[ "${TRSHELL_SUPPORTED_OPTIONS[@]}" =~ "$option" ]]; then
        echo "Function called exists is: $(type -t $function)"
        if [[ "$(type -t $function)" = "function" ]]; then
            echo "Executing function $function"
            $function
            return 0
        fi
    fi

    test.help $@
}

main $1
