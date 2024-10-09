
function hg.get_revision_from_project() {
    local projectUrl=$1
    local project=$2
    local branch=$3

    hg.clone_in_folder $projectUrl $project

    hg.update_project $project
    utils.error_and_exit "Cannot update project $project"
    hg.get_last_revision $project $branch
    utils.error_and_exit "Error getting last revision: $project $branch"

    local revision=$_r
    _r=$revision
}

function hg.get_last_revision() {
    local project=$1
    local branch=$2

    pushd $project > /dev/null
    
    local revision=$(hg identify --id --rev "$branch")
    _r=$revision
    if [ $? -ne 0 ]; then
        log.error "Error actualizando la rama $branch. Proceso detenido"
        return 1
    fi

    popd > /dev/null
}

function hg.update_project() {
    local project=$1

    pushd $project > /dev/null

    hg pull
    if [ $? -ne 0 ]; then
        log.error "Error pulling project $project"
        return 1
    fi

    popd > /dev/null
}

function hg.clone_in_folder() {
    local projectUrl=$1
    local folder=$2

    if [ ! -d "$folder" ]; then
        hg clone -U $projectUrl $folder
        if [ $? -ne 0 ]; then
            log.error "Error clonning projct $projectUrl. Proceso detenido"
            return 1
        fi

    else
        if [ ! -d "$folder/.hg" ]; then
            log.error "Folder provided is a folder already exists: $folder"
            return 1
        fi
    fi
}

function hg.get_all_branches() {
    local project=$1
    local user=$2

    pushd $project > /dev/null

    local branches=$(hg log -Tjson --keyword "$user" --template '{branch}\n' | sort | uniq)

    _r=$branches

    popd > /dev/null
}

function hg.get_all_active_branches() {
    local project=$1
    local user=$2

    hg.get_all_branches $project $user
    local branches=$_r

    for branch in $branches
    do
        hg.is_branch_active $project $branch
        local is_closed=$_r

        if [ $is_closed ]; then
            echo "$branch"
        fi
    done
}

function hg.is_branch_active() {
    local project=$1
    local branch=$2

    pushd $project > /dev/null

    local branchClosed=$(hg log -r "branch('$branch') and head() and (closed())" -T "{branch}")
    if [ -z "${branchClosed}" ]; then
        _r=false
    else
        _r=true
    fi
    log.trace "Branch $branch is closed? $_r"
    popd > /dev/null
}

