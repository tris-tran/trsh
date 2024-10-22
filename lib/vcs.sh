_load.load_once vcs && return 0

VCS_TYPE_HG="hg"
VCS_TYPE_GIT="git"

function vcs.get_repo_type() {
    local project=$1

    if git.is_git_repo $project; then
        _r=$VCS_TYPE_GIT
    elif [ -d "$project/.hg" ]; then
        _r=$VCS_TYPE_HG
    else
        log.error "Directory with no VCS"
        return 1
    fi
}

function _vcs.dispatch() {
    local project=$1
    local function=$2
    shift 2


    vcs.get_repo_type $project
    local type=$_r

    if [[ "$(type -f "${type}.${function}")" != "function" ]]; then
        log.error "No function $function for repositoy type $type" 
        return 1
    fi

    case $type in
        hg)
            hg.$function $project $@
        ;;

        git)
            git.$function $project $@
        ;;

        *)
            log.error "No repository type $project"
            return 1
            ;;
    esac
}
