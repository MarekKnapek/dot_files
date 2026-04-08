#!/usr/bin/env bash

set -x
set -e

if [ $# -ne 2 ]; then
	exit 1
fi

mk_gh_name="${1}"
mk_gh_repo="${2}"

git init --bare ${mk_gh_repo}.git
cd ${mk_gh_repo}.git
git remote add gh https://github.com/${mk_gh_name}/${mk_gh_repo}.git

git config --local core.repositoryformatversion 1
git config --local extensions.relativeWorktrees true
git config --local gc.auto 0
git config --local core.autocrlf false
git config --local core.compression 9
git config --local core.looseCompression 9
git config --local pack.compression 9
git config --local --add remote.gh.fetch +refs/heads/*:refs/remotes/gh/*
git config --local --add remote.gh.fetch +refs/tags/*:refs/tags/gh/*
git config --local --unset-all remote.gh.fetch
git config --local --add remote.gh.fetch +refs/heads/*:refs/remotes/gh/*
git config --local --add remote.gh.fetch +refs/tags/*:refs/tags/gh/*
git config --local remote.gh.tagOpt --no-tags

git fetch --all --force --prune

mk_gh_remote_branch="$(git symbolic-ref --short refs/remotes/gh/HEAD)"
mk_gh_branch="${mk_gh_remote_branch#*/}"
git worktree add --orphan -b ${mk_gh_branch} ../STL --relative-paths

cd ../${mk_gh_repo}
git reset --hard gh/${mk_gh_branch}
git branch --set-upstream-to=gh/${mk_gh_branch} ${mk_gh_branch}
git fetch --all --force --prune
git pull

cd ../${mk_gh_repo}.git
rm -rf hooks/
rm -rf info/exclude
rm -rf description
rm -rf packed-refs
rm -rf refs/tags/

rm -rf logs/
rm -rf worktrees/${mk_gh_repo}/logs/

cd ../${mk_gh_repo}
git clean -dfx
git reset --hard --
git fetch --all --force --prune
git pull

cd ../${mk_gh_repo}.git
rm -rf logs/
rm -rf worktrees/${mk_gh_repo}/logs/

cd ..
