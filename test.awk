#!/usr/bin/awk -f

BEGIN {
    FS="\n"
    OFS=""

    ESCAPE_TEST=")(}{"    
    if (match(ESCAPE_TEST, escapeRegex(ESCAPE_TEST))) {
    } else {
        print "CANNOT CONTINUE IMPOSSIBLE TO ESCAPE"
        exit 1
    }   

    redefineTags("{{", "}}")
}

function redefineTags(openTag, closeTag) {
    OPEN_TAG=escapeRegex(openTag)
    CLOSE_TAG=escapeRegex(closeTag)

    OPEN_TAG_LEN=length(openTag)
    CLOSE_TAG_LEN=length(closeTag)

    DELIMITER=OPEN_TAG"=.+ .+="CLOSE_TAG

    ANY_TAG=OPEN_TAG"[!#]? *[^{}]+ *"CLOES_TAG
    COMMENT=OPEN_TAG"! *[^{}]+ *"CLOSE_TAG

    NORMAL=OPEN_TAG"[^!#\\\{}] *[^{} ]+ *"CLOSE_TAG
    BLOCK=OPEN_TAG"# *[^{} ]+ *"CLOSE_TAG
    END_BLOCK=OPEN_TAG"\\\ *[^{} ]+ *"CLOSE_TAG

    END_BLOCK=OPEN_TAG"\\\ *[^{} ]+ *"CLOSE_TAG
}

function escapeRegex(regex) {
    result=""
    split(regex, chars, "")
    for(i=1; i<=length(regex); i++) { 
        c=chars[i]
        if (c == "(") c="\("
        else if (c == ")") c="\)"
        
        result = result c
    }
    return result
}

$0 !~ ANY_TAG { print $0; next }

function checkLine() {
    if ($0 !~ ANY_TAG) { print $0; return 1 }
    return 0
}

match($0, COMMENT) {
    do {
        removeTag("")
        if (checkLine()) { next }
    } while(match($0, COMMENT))
}
function removeTag(value) {
    $0=substr($0, 0, RSTART-1) value substr($0, RSTART + RLENGTH, length($0))
}

match($0, BLOCK) {
    print $0
    next
}

match($0, END_BLOCK) {
    print "END_BLOCK"
    next
}

match($0, NORMAL) {
    do {
        tag=substr($0, RSTART, RLENGTH)
        key=substr(tag, OPEN_TAG_LEN+1, length(tag)-CLOSE_TAG_LEN-OPEN_TAG_LEN)
        key=removeSpaces(key)
        value=getValue("", key)
        removeTag(value)
        if (checkLine()) { next }
    } while(match($0, NORMAL)) 
}

{print $0}

function getValue(keyPrefix, key) {
    finalKey=key
    if (keyPrefix) { finalKey=keyPrefix key } 
    value=LOCALENV[finalKey]
    if ( ! value) { return ENVIRON[finalKey] }
    return value
}

function removeSpaces(key) {
    gsub(/^[ \t]+|[ \t]+$/, "", key)
    return key
}
