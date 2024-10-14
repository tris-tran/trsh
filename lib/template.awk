#!/usr/bin/awk -f

BEGIN {
    keyList=0
    keyPrefix=0

    if (file) {
        saveFS=FS
        FS=OFS="="
        loadProperties(file)
        FS=OFS=saveFS
    }
}

function loadProperties(file) {
    while(getline < file) {
        LOCALENV[$1]=$2
    }
}

#{{ TAG }}
/{{[^!] *[^}{ ]+ *}}/ { 
    $0=subMoustacheLine(keyPrefix, $0)
}

#Conditional or list block
#{{{# LIST}}
/{{# *[^}{ ]+ *}}/ { 
    keyPrefix=getMoustacheListKey($0)
    print "LISTOPEN:"keyPrefix
    next
}

#{{\ END_LIST}}
/{{\\ *[^}{ ]+ *}}/ { 
    keyPrefix=0
    listKey=getMoustacheListKey($0)
    print "LISTCLOSE:"listKey
    next
}

#{{{! COMMENT}}
/{{! *[^}{]+ *}}/ { 
    $0=removeMoustacheTagInLine($0)
}

{print $0}

function removeMoustacheTagInLine(line) {
    while(match(line, /{{! *[^}]+ *}}/)) {
        moustacheTag=substr(line, RSTART, RLENGTH)
        sub(moustacheTag, "", line)
    }
    return line
}

function getMoustacheListKey(listTag) {
    listKey=substr(listTag, 4, length(listTag)-5)
    return removeSpaces(listKey)
}

function subMoustacheLine(keyPrefix, line) {
    while(match(line, /{{ *[^}{ ]+ *}}/)) {
        moustacheTag=substr(line, RSTART, RLENGTH)
        varName=substr(moustacheTag, 3, length(moustacheTag)-4)
        varName=removeSpaces(varName)
        varValue=getValueFromKey(keyPrefix, key)
        sub(moustacheTag, varValue, line)
    }
    return line
}

function getValueFromKey(keyPrefix, key) {
    finalKey=key
    if (keyPrefix) {
        finalKey=keyPrefix varName
    } 

    value=LOCALENV[finalKey]
    if ( ! value) {
        value=ENVIRON[finalKey]
    }

    return value
}

function removeSpaces(key) {
    gsub(/^[ \t]+|[ \t]+$/, "", key)
    return key
}
