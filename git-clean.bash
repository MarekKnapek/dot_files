#!/usr/bin/env bash

set -x
set -e

if [ $# -ne 2 ]; then
	exit 1
fi

mk_gh_name="${1}"
mk_gh_repo="${2}"

git clone --bare https://github.com/${mk_gh_name}/${mk_gh_repo}.git
cd ${mk_gh_repo}.git
mk_gh_branch="$(git rev-parse --abbrev-ref HEAD)"
git worktree add ../${mk_gh_repo} ${mk_gh_branch} --relative-paths --no-checkout

git config --local core.autocrlf false
git config --local core.compression 9
git config --local core.looseCompression 9
git config --local extensions.relativeWorktrees true
git config --local gc.auto 0
git config --local pack.compression 9
git config --local --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git config --local --add remote.origin.fetch +refs/tags/*:refs/tags/origin/*
git config --local --unset-all remote.origin.fetch
git config --local --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git config --local --add remote.origin.fetch +refs/tags/*:refs/tags/origin/*
git config --local remote.origin.tagOpt --no-tags

rm -rf hooks/
rm -rf info/exclude
rm -rf description
rm -rf packed-refs
rm -rf refs/tags/

cd ../${mk_gh_repo}
git fetch --all --force --prune
git pull origin ${mk_gh_branch}
git branch --set-upstream-to=origin/${mk_gh_branch} ${mk_gh_branch}

cd ../${mk_gh_repo}.git
rm -rf logs/
rm -rf worktrees/${mk_gh_repo}/logs/
rm -rf worktrees/${mk_gh_repo}/FETCH_HEAD
rm -rf worktrees/${mk_gh_repo}/index

cd ../${mk_gh_repo}
git clean -dfx
git reset --hard --

cd ../${mk_gh_repo}.git
rm -rf logs/
rm -rf worktrees/${mk_gh_repo}/logs/

cd ..
