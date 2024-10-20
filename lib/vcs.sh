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


_VCS_outgoing_DOC=$(cat <<-END
    Shows changes not in remote server
END
)
function vcs.outgoing() {
    local project=$1
    local origin=$2
    local branch=$3

    if [ ! -d $project ]; then
        project="."
        origin=$1
        branch=$2
    fi
    
    vcs.get_repo_type $project
    local type=$_r

    case $type in
        hg)
            hg.outgoing $project
        ;;

        git)
            git.outgoing $project $origin $branch
        ;;

        *)
            log.error "No repository type $project"
            return 1
            ;;
    esac
}
