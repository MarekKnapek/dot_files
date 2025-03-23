#!/bin/bash


#set -x
set -e


fn_help_and_exit()
{
	printf "Example usage:\n${0} 10 2000-01-01T00:00:00+00:00";
	exit 0;
}

fn_not_num()
{
	echo "Expected number." >& 2;
	exit 1;
}

fn_not_date()
{
	echo "Expected date." >& 2;
	exit 1;
}

fn_bad_date()
{
	echo "Bad date." >& 2;
	exit 1;
}

fn_bad_repo()
{
	echo "Something went wrong." >& 2;
	exit 1;
}

fn_next_date()
{
	if ! [[ ${var_date} =~ ${var_re_is_date} ]] ; then
		fn_not_date
	fi

	var_local_year="${BASH_REMATCH[1]}"
	var_local_month="${BASH_REMATCH[2]}"
	var_local_day="${BASH_REMATCH[3]}"
	var_local_hour="${BASH_REMATCH[4]}"
	var_local_minute="${BASH_REMATCH[5]}"
	var_local_second="${BASH_REMATCH[6]}"
	var_local_zone_hour="${BASH_REMATCH[7]}"
	var_local_zone_minute="${BASH_REMATCH[8]}"

	var_local_month="${var_local_month#0}"
	var_local_day="${var_local_day#0}"
	var_local_hour="${var_local_hour#0}"
	var_local_minute="${var_local_minute#0}"
	var_local_second="${var_local_second#0}"
	var_local_zone_hour="${var_local_zone_hour#0}"
	var_local_zone_minute="${var_local_zone_minute#0}"

	if ! [[ "${var_local_year}" -ge 1970 && "${var_local_year}" -le 2400 && "${var_local_month}" -ge 1 && "${var_local_month}" -le 12 && "${var_local_day}" -ge 1 && "${var_local_day}" -le 31 ]] ; then
		fn_bad_date
	fi
	if ! [[ "${var_local_hour}" -ge 0 && "${var_local_hour}" -le 23 && "${var_local_minute}" -ge 0 && "${var_local_minute}" -le 59 && "${var_local_second}" -ge 0 && "${var_local_second}" -le 59 ]] ; then
		fn_bad_date
	fi
	if ! [[ "${var_local_zone_hour}" -ge 0 && "${var_local_zone_hour}" -le 23 && "${var_local_zone_minute}" -ge 0 && "${var_local_zone_minute}" -le 59 ]] ; then
		fn_bad_date
	fi

	var_local_minute=$(( ${var_local_minute} + 1 ))
	if [ ${var_local_minute} -eq 60 ] ; then
		var_local_minute=0
		var_local_hour=$(( ${var_local_hour} + 1 ))
		if [ ${var_local_hour} -eq 24 ] ; then
			var_local_hour=0
			var_local_day=$(( ${var_local_day} + 1 ))
			# todo if day >= 28 or 29 or 30 or 31
		fi
	fi

	if [[ ${#var_local_month} -lt 2 ]] ; then var_local_month="0${var_local_month}"; fi
	if [[ ${#var_local_day} -lt 2 ]] ; then var_local_day="0${var_local_day}"; fi
	if [[ ${#var_local_hour} -lt 2 ]] ; then var_local_hour="0${var_local_hour}"; fi
	if [[ ${#var_local_minute} -lt 2 ]] ; then var_local_minute="0${var_local_minute}"; fi
	if [[ ${#var_local_second} -lt 2 ]] ; then var_local_second="0${var_local_second}"; fi
	if [[ ${#var_local_zone_hour} -lt 2 ]] ; then var_local_zone_hour="0${var_local_zone_hour}"; fi
	if [[ ${#var_local_zone_minute} -lt 2 ]] ; then var_local_zone_minute="0${var_local_zone_minute}"; fi

	var_date="${var_local_year}-${var_local_month}-${var_local_day}T${var_local_hour}:${var_local_minute}:${var_local_second}+${var_local_zone_hour}:${var_local_zone_minute}"
}


if [ $# -ne 2 ] ; then
	fn_help_and_exit
fi

var_count=$( git log --oneline HEAD ^"$1" | wc -l  )
var_date=$2

var_re_is_num="^[1-9][0-9]*$"
var_re_is_date="^([1-9][0-9]{3})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})\+([0-9]{2}):([0-9]{2})$"

if ! [[ ${var_count} =~ ${var_re_is_num} ]] ; then
	fn_not_num
fi
if ! [[ ${var_date} =~ ${var_re_is_date} ]] ; then
	fn_not_date
fi

var_year="${BASH_REMATCH[1]}"
var_month="${BASH_REMATCH[2]}"
var_day="${BASH_REMATCH[3]}"
var_hour="${BASH_REMATCH[4]}"
var_minute="${BASH_REMATCH[5]}"
var_second="${BASH_REMATCH[6]}"
var_zone_hour="${BASH_REMATCH[7]}"
var_zone_minute="${BASH_REMATCH[8]}"

var_month="${var_month#0}"
var_day="${var_day#0}"
var_hour="${var_hour#0}"
var_minute="${var_minute#0}"
var_second="${var_second#0}"
var_zone_hour="${var_zone_hour#0}"
var_zone_minute="${var_zone_minute#0}"

if ! [[ "${var_year}" -ge 1970 && "${var_year}" -le 2400 && "${var_month}" -ge 1 && "${var_month}" -le 12 && "${var_day}" -ge 1 && "${var_day}" -le 31 ]] ; then
	fn_bad_date
fi
if ! [[ "${var_hour}" -ge 0 && "${var_hour}" -le 23 && "${var_minute}" -ge 0 && "${var_minute}" -le 59 && "${var_second}" -ge 0 && "${var_second}" -le 59 ]] ; then
	fn_bad_date
fi
if ! [[ "${var_zone_hour}" -ge 0 && "${var_zone_hour}" -le 23 && "${var_zone_minute}" -ge 0 && "${var_zone_minute}" -le 59 ]] ; then
	fn_bad_date
fi

if [[ ${#var_month} -lt 2 ]] ; then var_month="0${var_month}"; fi
if [[ ${#var_day} -lt 2 ]] ; then var_day="0${var_day}"; fi
if [[ ${#var_hour} -lt 2 ]] ; then var_hour="0${var_hour}"; fi
if [[ ${#var_minute} -lt 2 ]] ; then var_minute="0${var_minute}"; fi
if [[ ${#var_second} -lt 2 ]] ; then var_second="0${var_second}"; fi
if [[ ${#var_zone_hour} -lt 2 ]] ; then var_zone_hour="0${var_zone_hour}"; fi
if [[ ${#var_zone_minute} -lt 2 ]] ; then var_zone_minute="0${var_zone_minute}"; fi

var_date="${var_year}-${var_month}-${var_day}T${var_hour}:${var_minute}:${var_second}+${var_zone_hour}:${var_zone_minute}"
var_batch=10
var_count_mo=$(( ${var_count} - 1 ))
var_count_batch=$(( ${var_count} / ${var_batch} ))
var_count_batch_mo=$(( ${var_count_batch} - 1 ))

declare -i var_i=0
for var_i in $(seq 0 ${var_count_batch_mo});
do
	var_i=$(( ${var_i} * ${var_batch} ))
	var_rem=$(( ${var_count} - ${var_i}  ))
	var_log="$(git log -n ${var_rem} --pretty=format:%H)"
	if IFS=$'\n' read -rd "" -a var_hashes; then :; fi <<< ${var_log}
	var_hashes_count=${#var_hashes[@]}
	if ! [ ${var_hashes_count} -eq ${var_rem} ] ; then
		bad_repo
	fi
	var_env_filter=""
	declare -i var_ii=0
	for var_ii in $(seq 0 $(( ${var_batch} - 1  )) );
	do
		var_j=$(( ${var_rem} - 1 - ${var_ii} ))
		var_hash=${var_hashes[${var_j}]}
		var_env_filter="${var_env_filter}if [ \$GIT_COMMIT = ${var_hash} ] ; then export GIT_AUTHOR_DATE=${var_date} ; export GIT_COMMITTER_DATE=${var_date} ; fi;"
		fn_next_date
	done
	FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter "${var_env_filter}" HEAD~${var_rem}..HEAD > /dev/null 2> /dev/null
done

declare -i var_i=0
for var_i in $(seq $(( ${var_count_batch} * ${var_batch} )) ${var_count_mo});
do
	var_rem=$(( ${var_count} - ${var_i}  ))
	var_log="$(git log -n ${var_rem} --pretty=format:%H)"
	if IFS=$'\n' read -rd "" -a var_hashes; then :; fi <<< ${var_log}
	var_hashes_count=${#var_hashes[@]}
	if ! [ ${var_hashes_count} -eq ${var_rem} ] ; then
		bad_repo
	fi
	var_j=$(( ${var_rem} - 1 ))
	var_hash=${var_hashes[${var_j}]}
	var_env_filter="if [ \$GIT_COMMIT = ${var_hash} ] ; then export GIT_AUTHOR_DATE=${var_date} ; export GIT_COMMITTER_DATE=${var_date} ; fi;"
	FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter "${var_env_filter}" HEAD~${var_rem}..HEAD > /dev/null 2> /dev/null
	fn_next_date
done
