#!/bin/bash

TRSH="$HOME/.trshell"
REPO="trshell"
REMOTE="git@github.com:tris-tran/${REPO}.git"
BRANCH="master"

GIT_REMOTE="origin"

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

command_exists git || return 1

rm -rf $TRSH #DELETE!!!
if [ -d "$TRSH" ]; then
    echo "Folder $TRSH alredy exits"
    exit 1
fi

# Prevent the cloned repository from having insecure permissions. Failing to do
# so causes compinit() calls to fail with "command not found: compdef" errors
# for users with insecure umasks (e.g., "002", allowing group writability). Note
# that this will be ignored under Cygwin by default, as Windows ACLs take
# precedence over umasks except for filesystems mounted with option "noacl".
umask g-w,o-w


git init --quiet "$TRSH" && pushd "$TRSH" > /dev/null \
    && git config core.eol lf \
    && git config core.autocrlf false \
    && git config fsck.zeroPaddedFilemode ignore \
    && git config fetch.fsck.zeroPaddedFilemode ignore \
    && git config receive.fsck.zeroPaddedFilemode ignore \
    && git remote add origin "$REMOTE" \
    && git fetch --depth=1 origin \
    && git checkout -b "$BRANCH" "origin/$BRANCH" || 
    {
        [ ! -d "$TRSH" ] || {
        popd > /dev/null
            rm -rf "$TRSH" 2>/dev/null
        }
        echo "git clone of trshell repo failed"
        exit 1
    }

cp $TRSH/templates/trshrc.trsh-templates $HOME/.trshrc


