#!/bin/bash

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
    
    local lastCommand=$(history 1 | awk '{$1=""; print $0}')
    _theme.add_ps1 $BRED $WHT " SSH TERMINAL [\[\u\]@\[\h\]] \[$DEF\][$lastCommand ]\[\n\]"

    if [[ $RETVAL == 0 ]]; then
        PS1="$PS1\[$BLK$BMGN\]>$RETVAL<\[$DEF\]"
    else
        PS1="$PS1\[$BLK$BRED\]>$RETVAL<\[$DEF\]"
    fi

    for (( nhost=0; nhost<$SSHE_DEPTH; nhost++ ))
    do
        _theme.add_ps1 $BMGN $BLK "\[$BLD\]$C_NEXT [$nhost]"
    done
    #_theme.add_ps1 $BYLW $BLK "$BLD\[$SSHE_DEPTH\]"
    _theme.add_ps1 $MGN $BBLU "$SEPARATOR"
    _theme.add_ps1 $BBLU $BLK " \[$BLD\d\] \[\t\] "
    _theme.add_ps1 $BGRN $BLU "$SEPARATOR"
    _theme.add_ps1 $BGRN $BLK " \[$BLD\u\]@\[\h\] "
    _theme.add_ps1 $BCYN $GRN "$SEPARATOR"
    _theme.add_ps1 $BCYN $BLK " \[$BLD\] \[\w\] "
    _theme.add_ps1 $DEF $CYN "$SEPARATOR \[$BLD$DEF\]"
    #_theme.add_ps1 $DEF $CYN "$SEPARATOR $DEF"

    #PS1="$BYLW\[$SSHE_DEPTH\]$DEF$YLW$BBLU$SEPARATOR$DEF$BBLU\[\d \t\]$DEF$BLU$SEPARATOR$DEF\u@\h \w $SEPARATOR "   
}
