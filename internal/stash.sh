_load.load_once stash && return 0

_STASH_upload_script_DOC=$(cat <<-END
    Hace el upload de un script
END
)
function stash.script() {
    local scriptFile=$1
    local scriptFileName=$(basename "$scriptFile")

    _stash.init_user
    
    cp "$scriptFile" "$TRSH_STASH/$TRSH_USER/scripts"

    git.add_file "$TRSH_STASH" "$TRSH_USER/scripts/$scriptFileName"
    git.commit "$TRSH_STASH" "Script: $scriptFileName User: $TRSH_USER"
    git.push "$TRSH_STASH" "origin" "master"
}

_STASH_upload_function_DOC=$(cat <<-END
    Hace el upload de una funcion
END
)
function stash.function() {
    log.error "Upload function"
    local function=$1
    local fileInProject="$TRSH_USER/functions/$function"

    local temp=$(mktemp)
    #Loading all user-declared functions
    echo "declare -f $function > $temp" | bash -i
    source $temp
    rm $temp

    if [[ "$(type -t $function)" = "function" ]]; then
        echo "$(declare -f $function)" > "$TRSH_STASH/$fileInProject"

        git.add_file "$TRSH_STASH" $fileInProject
        git.commit "$TRSH_STASH" "Function:$function User:$TRSH_USER"
        git.push "$TRSH_STASH" "origin" "master"
    else
        log.error "Function $function does not exists"
        exit 1
    fi
}

_STASH_upload_oneliner_DOC=$(cat <<-END
    Hace el upload de un oneliner de shell
END
)
function stash.oneliner() {
    log.error "Uload oneliner"
    local name=$1
    local fileInProject="$TRSH_USER/oneliners/$name"
    local temp=$(mktemp)

    if [ -f "$TRSH_STASH/$fileInProject" ]; then
        cp "$TRSH_STASH/$fileInProject" "$temp"
    fi

    $EDITOR $temp

    local oneliner=$(cat $temp)

    if [ -z "$oneliner" ]; then
        log.red "No content" 
        rm "$TRSH_STASH/$fileInProject"
    else    
        cp "$temp" "$TRSH_STASH/$fileInProject"
        rm $temp
    fi


    git.add_file "$TRSH_STASH" $fileInProject
    git.commit "$TRSH_STASH" "Function:$function User:$TRSH_USER"
    git.push "$TRSH_STASH" "origin" "master"
}

function _stash.init_user() {
    log.red "Stash dir: $TRSH_STASH"
    pushd $TRSH_STASH >> /dev/null

    git merge --no-commit --no-ff "master" > /dev/null

    mkdir -p $TRSH_USER/functions
    mkdir -p $TRSH_USER/oneliners
    mkdir -p $TRSH_USER/scripts

    popd > /dev/null
}
