#!/bin/bash
#

. ./log.sh
. ./utils.sh
. ./hg.sh
. ./git.sh

git.get_revision_from_project git@git-central.g3stiona.com:aspose.git aspose origin master

