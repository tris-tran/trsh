_load.load_once update-trshell && return 0

function update-trshell.needs_update() {
    local dist=$1

    pushd $dist > /dev/null

    git fetch

    local localRev=$(git rev-parse master)
    local originRev=$(git rev-parse origin/master)

    if [ "$localRev" != "$originRev" ]; then
        _r=true
    else
        _r=false
    fi

    popd > /dev/null
}

function update-trshell.update() {
    local dist=$1
    update-trshell.show_info $1

}

function update-trshell.show_info() {
    local dist=$1
    log.green "Updating trshell in: $dist"

    pushd $dist > /dev/null
    git reset > /dev/null
    git clean -f > /dev/null
    log.line
    log.green "Changes in the last update"
    git --no-pager log ..origin/master --oneline 
    log.line
    log.green "File changes in the update"
    git --no-pager diff origin/master --stat
    git merge > /dev/null
    popd > /dev/null
}
