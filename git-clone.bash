#!/usr/bin/env bash

set -x
set -e

if [ $# -ne 2 ]; then
	exit 1
fi

mk_url="${1}"
mk_dir="${2}"

git init --bare "${mk_dir}".git
cd "${mk_dir}".git
git remote add origin "${mk_url}"

git config --local core.repositoryformatversion 1
git config --local extensions.relativeWorktrees true

git config --local core.autocrlf false
git config --local core.compression 9
git config --local core.looseCompression 9
git config --local gc.auto 0
git config --local gc.pruneExpire never
git config --local gc.reflogExpire never
git config --local pack.compression 9

git config --local --unset-all remote.origin.fetch
git config --local --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git config --local --add remote.origin.fetch +refs/tags/*:refs/tags/origin/*
git config --local remote.origin.tagOpt --no-tags

git fetch --all --force --prune

mk_remote_branch="$(git symbolic-ref --short refs/remotes/origin/HEAD)"
mk_branch="${mk_remote_branch#*/}"
git worktree add --orphan -b "${mk_branch}" ../"${mk_dir}" --relative-paths

cd ../"${mk_dir}"
git reset --hard origin/"${mk_branch}"
git branch --set-upstream-to=origin/"${mk_branch}" "${mk_branch}"
git fetch --all --force --prune
git pull

cd ../"${mk_dir}".git
rm -rf hooks/
rm -rf info/exclude
rm -rf description
rm -rf packed-refs
rm -rf refs/tags/

rm -rf logs/
rm -rf worktrees/"${mk_dir}"/logs/

cd ../"${mk_dir}"
git clean -dfx
git reset --hard --
git fetch --all --force --prune
git pull

cd ../"${mk_dir}".git
rm -rf logs/
rm -rf worktrees/"${mk_dir}"/logs/

cd ..
