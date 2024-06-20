function timer_start
{
	timer=${timer:-$SECONDS}
}

function timer_stop
{
	timer_show=$(($SECONDS - $timer))
	unset timer
}

trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
	PROMPT_COMMAND="timer_stop"
else
	PROMPT_COMMAND="$PROMPT_COMMAND; timer_stop"
fi

PS1='[${timer_show}][$?][\w]$ '
PS1="$PS1"'\u@\h \[\033[0m\][${timer_show}][$?] ' # user@host<space>
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;32m\]\u\[\033[0m\]@\[\033[32m\]\h\[\033[0m\] [${timer_show}][$?] \[\033[33m\]\w\[\033[0m\]\n$ '
