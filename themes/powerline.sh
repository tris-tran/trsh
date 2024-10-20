

function theme.define() {
    declare -g -A fore
    declare -g -A back

    fore[reset]="\e[38;5;0m"
    back[reset]="\e[48;5;0m"

    SEPARATOR=$'\ue0b0'
}

function theme.eval() {
    PS1="\[$SSHE_DEPTH\]$SEPARATOR\[\d \t\]$SEPARATOR\u@\h \w $SEPARATOR "   
}
