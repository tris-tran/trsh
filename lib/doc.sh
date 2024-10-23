
require doc "
" || return 0

function doc.library() {
    @deprecated

    local loadFrom=$TRSH_DIST
    
    allLibs=( ${_LOAD_INTERNALS[@]} ${_LOAD_LIBS[@]} )

    allFunctions=""
    for lib in ${allLibs[@]}
    do
        internalLibPath="$loadFrom/internal/${lib}.sh"
        normallibPath="$loadFrom/lib/${lib}.sh"
        if [ -f "$internalLibPath" ]; then
            doc.describe $internalLibPath $lib > $TRSH_DIST/doc/${lib}.md
        elif [ -f "$normallibPath" ]; then
            doc.describe $normallibPath $lib > $TRSH_DIST/doc/${lib}.md
        else
            log.red "WTF $lib"
            exit 1
        fi
        allFunctions+=$'\n'"$_r"
    done 

    echo "$allFunctions" | LC_COLLATE=C sort -r > $TRSH_DIST/doc/all-functions.md


}

function doc.describe() {
    script=$1
    lib=$2

    comd=$(cat <<- END
    function _load.load_once(){ return 1; }
    function require() { return 0; }
    source $script
    
    declare -F | awk -v lib=$lib '
        \$3 ~ "^[_]?"lib { print \$3; next }
        {}
    '
END
)
    libFunctions=$(env -i bash -c "$comd" 2>/dev/null)

    echo "# Functions"
    for function in $libFunctions
    do
        echo "- [$function]($function)"
    done

    awk 'BEGIN { FS=" |[(]"; nAccC=0 }
    /^#/ { accC[nAccC]=$0; nAccC+=1; }
    $0 !~ /^function/ && $0 !~ /^#/ { delete accC; nAccC=0; }
    /^function/ {
        print "# " $2
        for ( i=0; i<=nAccC; i++ ) {
            print substr(accC[i], 2)
        }
    }' $script

    _r="$libFunctions"
}
