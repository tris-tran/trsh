
require colors "
" || return 0


FG_RED=$(tput setaf 1)
FG_GREEN=$(tput setaf 2)
FG_ORANGE=$(tput setaf 3)
COLOR_RESET=$(tput sgr0)

function colors.define() {
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
    set +a
}
