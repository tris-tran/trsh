function theme.define() {
    set -a
    #--------------------------------------------------------------------+
    #Color picker, usage: printf $BLD$CUR$RED$BBLU'Hello World!'$DEF     |
    #-------------------------+--------------------------------+---------+
    #       Text color        |       Background color         |         |
    #-----------+-------------+--------------+-----------------+         |
    # Base color|Lighter shade| Base color   | Lighter shade   |         |
    #-----------+-------------+--------------+-----------------+         |
    BLK='\e[30m'; blk='\e[90m'; BBLK='\e[40m'; bblk='\e[100m' #| Black   |
    RED='\e[31m'; red='\e[91m'; BRED='\e[41m'; bred='\e[101m' #| Red     |
    GRN='\e[32m'; grn='\e[92m'; BGRN='\e[42m'; bgrn='\e[102m' #| Green   |
    YLW='\e[33m'; ylw='\e[93m'; BYLW='\e[43m'; bylw='\e[103m' #| Yellow  |
    BLU='\e[34m'; blu='\e[94m'; BBLU='\e[44m'; bblu='\e[104m' #| Blue    |
    MGN='\e[35m'; mgn='\e[95m'; BMGN='\e[45m'; bmgn='\e[105m' #| Magenta |
    CYN='\e[36m'; cyn='\e[96m'; BCYN='\e[46m'; bcyn='\e[106m' #| Cyan    |
    WHT='\e[37m'; wht='\e[97m'; BWHT='\e[47m'; bwht='\e[107m' #| White   |
    #-------------------------{ Effects }----------------------+---------+
    DEF='\e[0m'   #Default color and effects                             |
    BLD='\e[1m'   #Bold\brighter                                         |
    DIM='\e[2m'   #Dim\darker                                            |
    CUR='\e[3m'   #Italic font                                           |
    UND='\e[4m'   #Underline                                             |
    INV='\e[7m'   #Inverted                                              |
    COF='\e[?25l' #Cursor Off                                            |
    CON='\e[?25h' #Cursor On                                             |
    #--------------------------------------------------------------------+

    SEPARATOR=$'\ue0b0'
    C_PROPMPT=$'\u03bb'
    C_NEXT=$'\u22d9'
    C_INITIAL=$'\u279c'
    set +a
}

function theme.eval() {
    local RETVAL=$?
    PS1=""

    function _theme.add_ps1() {
        local bg=$1
        local fg=$2
        shift
        shift
        PS1="$PS1\[$bg$fg\]$1\[$DEF\]"
    }

    #PROMPT_COMMAND="[[ $? == 0 ]] && export P_EXIT=$BCYN || export P_EXIT=$BRED"

    if [[ $RETVAL == 0 ]]; then
        PS1="$PS1\[$C_INITIAL\] \[$DEF\]"
    else
        PS1="$PS1\[$RED\]\[$C_INITIAL\] \[$DEF\]"
    fi

    for (( nhost=0; nhost<$SSHE_DEPTH; nhost++ ))
    do
        _theme.add_ps1 $DEF $GRN "\[$BLD\]\[$C_INITIAL\] [$nhost]"
    done
    #_theme.add_ps1 $BYLW $BLK "$BLD\[$SSHE_DEPTH\]"
    _theme.add_ps1 $DEF $BLK "|"
    _theme.add_ps1 $DEF $RED "\[$BLD\] SSH "
    _theme.add_ps1 $DEF $BLU " \[$BLD\u\]@\[\h\] "
    _theme.add_ps1 $DEF $CYN " \[$BLD\] \[\w\] "
    _theme.add_ps1 $DEF $CYN "\[$BLD\]\[$C_PROPMPT\] \[$BLD$DEF\]"
    #_theme.add_ps1 $DEF $CYN "$SEPARATOR $DEF"

    #PS1="$BYLW\[$SSHE_DEPTH\]$DEF$YLW$BBLU$SEPARATOR$DEF$BBLU\[\d \t\]$DEF$BLU$SEPARATOR$DEF\u@\h \w $SEPARATOR "   
}
