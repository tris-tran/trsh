#!/bin/bash

DIR="$HOME/.trshell"

REPO="tristan-scripts"
REMOTE="git@github.com:tris-tran/${REPO}.git"
BRANCH="master"

GIT_REMOTE="origin"

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

command_exists git || return 1

rm -rf $DIR #DELETE!!!
if [ -d "$DIR" ]; then
    echo "Folder $DIR alredy exits"
    exit 1
fi

# Prevent the cloned repository from having insecure permissions. Failing to do
# so causes compinit() calls to fail with "command not found: compdef" errors
# for users with insecure umasks (e.g., "002", allowing group writability). Note
# that this will be ignored under Cygwin by default, as Windows ACLs take
# precedence over umasks except for filesystems mounted with option "noacl".
umask g-w,o-w


git init --quiet "$DIR" && pushd "$DIR" > /dev/null \
    && git config core.eol lf \
    && git config core.autocrlf false \
    && git config fsck.zeroPaddedFilemode ignore \
    && git config fetch.fsck.zeroPaddedFilemode ignore \
    && git config receive.fsck.zeroPaddedFilemode ignore \
    && git remote add origin "$REMOTE" \
    && git fetch --depth=1 origin \
    && git checkout -b "$BRANCH" "origin/$BRANCH" 
    || {
        [ ! -d "$DIR" ] || {
        popd > /dev/null
            rm -rf "$DIR" 2>/dev/null
        }
        echo "git clone of trshell repo failed"
        exit 1
    }

