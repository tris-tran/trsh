_load.load_once trshell && return 0

function trshell.init() {
    echo "SASD"

}

function trshell.update() {
(
    update-trshell.needs_update $TRSH_DIST
    if [ $_r = true ]; then

        update-trshell.update $TRSH_DIST
        exec $0 $@
        exit 0
    fi
)& > /dev/null
}

