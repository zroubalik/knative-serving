#!/bin/bash

# Usage: create-release-branch.sh v0.4.1 release-0.4

release=$1
target=$2

git fetch upstream --tags
git checkout -b "$target" "$release"

git checkout master openshift OWNERS_ALIASES OWNERS Makefile
make generate-dockerfiles
git add openshift OWNERS_ALIASES OWNERS Makefile
git commit -m "Add openshift specific files."