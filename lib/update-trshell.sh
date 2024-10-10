
function update-trshell.update() {
    local dist=$1
    update-trshell.show_info $1
}

function update-trshell.show_info() {
    local dist=$1
    log.green "Updating trshell in: $dist"

    git fetch
    
}
