#!/usr/bin/env bash

mk_git_prompt()
{
        local mk_branch_long="$(git symbolic-ref HEAD 2> /dev/null | cut -d "/" -f3)"
        local mk_branch_short="${mk_branch_long:0:30}"
        if (( ${#mk_branch_long} > ${#mk_branch_short} )); then
                mk_branch_long="${mk_branch_short}..."
        fi
        [ -n "${mk_branch_long}" ] && echo " (${mk_branch_long})"
}
mk_git_prompt
