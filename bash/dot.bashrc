# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# replace unix-word-rubout with backward-kill-word
if [ ! -z "${TERM}" ] && [ "${TERM}" != "dumb" ]
then
    stty werase undef
    bind '"\C-w": backward-kill-word'
fi

# bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# define prompt colors
# use another color on hosts from my employer
if hostname 2>&1 | grep -qi 'transip' || hostname -f 2>&1 | grep -qi 'transip'
then
    basecolor="\e[1;34m"
else
    basecolor="\e[1;32m"
fi

# format prompt, based on uid
if [ "$(whoami)" = "root" ]
then
    PS1="\[\e[1;31m\][${basecolor}\u@$(hostname -f 2>/dev/null || hostname) \W\e[1;31m]#\[\e[0m\] "
else
    PS1="\[${basecolor}\][\u@$(hostname -f 2>/dev/null || hostname) \W]\\$\[\e[0m\] "
fi

# prefer vim over vi
if [ ! -z "$(which vim)" -a -x "$(which vim)" ]
then
    alias vi="vim"
fi

# always keep environment when user sudo
alias sudo="sudo -E"

# run python script on startup python interactive mode
# in my case this script takes care of my history when using interactive mode
if [ -r ${HOME}/.pystartup ]
then
    PYTHONSTARTUP=${HOME}/.pystartup; export PYTHONSTARTUP
fi
