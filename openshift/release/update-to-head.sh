#!/bin/bash

# Usage: update-to-head.sh release-0.5

target=$1

git checkout "$target"
git fetch upstream master
git rebase upstream/master

git checkout master openshift OWNERS_ALIASES OWNERS Makefile
make generate-dockerfiles
git add openshift OWNERS_ALIASES OWNERS Makefile
git commit -m "Update openshift specific files."