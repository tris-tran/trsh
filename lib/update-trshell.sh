
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
    git --no-pager log ..origin/master --oneline 
    git --no-pager diff origin/master --stat
    git merge > /dev/null
    popd > /dev/null
}
