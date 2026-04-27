#!/usr/bin/env bash

function mk_set_term
{
	if [ "${TERM}" == "screen" ]; then
		export TERM="screen.xterm-256color";
	else
		export TERM="xterm-256color";
	fi
}

function mk_set_less_colors
{
	unset -v LESS_TERMCAP_mb
	unset -v LESS_TERMCAP_md
	unset -v LESS_TERMCAP_me
	unset -v LESS_TERMCAP_mh
	unset -v LESS_TERMCAP_mr
	unset -v LESS_TERMCAP_se
	unset -v LESS_TERMCAP_so
	unset -v LESS_TERMCAP_ue
	unset -v LESS_TERMCAP_us
	unset -v LESS_TERMCAP_ZN
	unset -v LESS_TERMCAP_ZO
	unset -v LESS_TERMCAP_ZV
	unset -v LESS_TERMCAP_ZW
	unset -v TERMCAP

	local mk_term_8col_fg_black="\e[30m"
	local mk_term_8col_fg_red="\e[31m"
	local mk_term_8col_fg_green="\e[32m"
	local mk_term_8col_fg_yellow="\e[33m"
	local mk_term_8col_fg_blue="\e[34m"
	local mk_term_8col_fg_magenta="\e[35m"
	local mk_term_8col_fg_cyan="\e[36m"
	local mk_term_8col_fg_white="\e[37m"
	local mk_term_8col_fg_default="\e[39m"

	local mk_term_8col_bg_black="\e[40m"
	local mk_term_8col_bg_red="\e[41m"
	local mk_term_8col_bg_green="\e[42m"
	local mk_term_8col_bg_yellow="\e[43m"
	local mk_term_8col_bg_blue="\e[44m"
	local mk_term_8col_bg_magenta="\e[45m"
	local mk_term_8col_bg_cyan="\e[46m"
	local mk_term_8col_bg_white="\e[47m"
	local mk_term_8col_bg_default="\e[49m"

	local mk_term_reset="\e[0m"
	local mk_term_bold="\e[1m"
	local mk_term_underline="\e[4m"

	export LESS_TERMCAP_md=$(printf "${mk_term_bold}${mk_term_8col_fg_green}") # Start bold mode
	export LESS_TERMCAP_me=$(printf "${mk_term_reset}") # End all mode like so, us, mb, md, and mr
	export LESS_TERMCAP_so=$(printf "${mk_term_bold}${mk_term_8col_fg_yellow}${mk_term_8col_bg_blue}") # Start standout mode
	export LESS_TERMCAP_se=$(printf "${mk_term_reset}") # End standout mode
	export LESS_TERMCAP_us=$(printf "${mk_term_underline}${mk_term_8col_fg_cyan}") # Start underlining
	export LESS_TERMCAP_ue=$(printf "${mk_term_reset}") # End underlining

	export MANPAGER="less"
	export PAGER="less"
	export GROFF_NO_SGR=1
}


function mk_timer_start
{
	mk_timer_before="${mk_timer_before:-$SECONDS}"
}

function mk_timer_stop
{
	local mk_timer_after=0
	local mk_seconds_total=0
	local mk_minutes_total=0
	local mk_hours_total=0
	local mk_days_total=0
	local mk_seconds_cur=0
	local mk_minutes_cur=0
	local mk_hours_cur=0
	local mk_days_cur=0
	local mk_hours_disp=""
	local mk_minutes_disp=""
	local mk_seconds_disp=""

	mk_timer_after="${SECONDS}"
	mk_seconds_total=$(( "${mk_timer_after}" - "${mk_timer_before}" ))
	mk_minutes_total=$(( "${mk_seconds_total}" / 60  ))
	mk_hours_total=$(( "${mk_minutes_total}" / 60  ))
	mk_days_total=$(( "${mk_hours_total}" / 24  ))
	mk_seconds_cur=$(( "${mk_seconds_total}" % 60  ))
	mk_minutes_cur=$(( "${mk_minutes_total}" % 60  ))
	mk_hours_cur=$(( "${mk_hours_total}" % 24  ))
	mk_days_cur=$(( "${mk_days_total}" ))
	if [[ ${#mk_hours_cur} -lt 2 ]]; then mk_hours_disp="0${mk_hours_cur}"; else mk_hours_disp="${mk_hours_cur}"; fi
	if [[ ${#mk_minutes_cur} -lt 2 ]]; then mk_minutes_disp="0${mk_minutes_cur}"; else mk_minutes_disp="${mk_minutes_cur}"; fi
	if [[ ${#mk_seconds_cur} -lt 2 ]]; then mk_seconds_disp="0${mk_seconds_cur}"; else mk_seconds_disp="${mk_seconds_cur}"; fi
	mk_timer_display="${mk_days_cur}+${mk_hours_disp}:${mk_minutes_disp}:${mk_seconds_disp}"
	unset mk_timer_before
}

function mk_git_prompt()
{
	local mk_branch_path=""
	local mk_branch_name=""

	mk_branch_path="$(git symbolic-ref HEAD 2> /dev/null)"
	if [ ${?} -ne 0 ]; then
		echo "";
	else
		mk_branch_name="$(echo "${mk_branch_path}" | cut -d "/" -f3)";
		echo " (${mk_branch_name})";
	fi
}

function mk_git_prompt()
{
	local mk_branch_path=""
	local mk_branch_name=""

	mk_branch_path="$(git symbolic-ref HEAD 2> /dev/null)"
	if [ ${?} -ne 0 ]; then
		echo "";
	else
		mk_branch_name="${mk_branch_path#"refs/heads/"}";
		echo " (${mk_branch_name})";
	fi
}

function mk_make_prompt
{
	local prompt=""

	prompt="" # clear
	if [ "$(whoami)" == "root" ];
	then
		prompt="${prompt}""\[\e[31m\e[1m\]" # red bold
	else
		prompt="${prompt}""\[\e[32m\]" # green
	fi
	prompt="${prompt}""\\\\u" # user name
	prompt="${prompt}""\[\e[0m\]" # reset
	prompt="${prompt}""@" # @
	prompt="${prompt}""\[\e[32m\]" # green
	prompt="${prompt}""\h" # host name
	prompt="${prompt}""\[\e[0m\]" # reset
	prompt="${prompt}"" " # space
	prompt="${prompt}"'[${mk_timer_display}]' # time
	prompt="${prompt}"'[${?}]' # last error
	prompt="${prompt}"" " # space
	prompt="${prompt}""\[\e[33m\]" # yellow
	prompt="${prompt}""\w" # current working directory
	prompt="${prompt}""\[\e[0m\]" # reset
	prompt="${prompt}""\[\e[36m\]" # cyan
	prompt="${prompt}""\$(mk_git_prompt)" # git
	prompt="${prompt}""\[\e[0m\]" # reset
	prompt="${prompt}""\\n" # nl
	prompt="${prompt}""\\$ " # $ space
	printf "${prompt}"
}
