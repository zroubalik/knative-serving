#!/usr/bin/env bash

# Synchs the release-next branch to master and then triggers CI
# Usage: update-to-head.sh

# Reset release-next to upstream/master.
git checkout upstream/master -B release-next

# Update openshift's master and take all needed files from there.
git fetch openshift master
git checkout openshift/master openshift OWNERS_ALIASES OWNERS Makefile
make generate-dockerfiles
git add openshift OWNERS_ALIASES OWNERS Makefile
git commit -m "Update openshift specific files."
git push -f openshift release-next

git checkout release-next -B release-next-ci
date > ci
git add ci
git commit -m "Triggering CI on branch 'release-next' after synching to head"
git push -f openshift release-next-ci

if hash hub 2>/dev/null; then
   hub pull-request --no-edit -l "kind/sync-fork-to-upstream" -b openshift:release-next -h openshift:release-next-ci
else
   echo "hub (https://github.com/github/hub) is not installed, so you'll need to create a PR manually."
fi
