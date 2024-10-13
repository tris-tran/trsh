_load.load_once template && return 0

_TEMPLATE_AWK_MOUSTACHE=$(cat ./lib/template.awk)
_TEMPLATE_EXTENSION=".trsh-template"

function _template.moustache_awk() {
    local file=$1
    local output=$2
    awk "$_TEMPLATE_AWK_MOUSTACHE" < $file > $output
}

function template.apply() {
    local templateName=$1
    local output=$2
    local template="$TRSH_DIR/templates/$templateName$_TEMPLATE_EXTENSION"

    _template.moustache_awk $template $output
}
