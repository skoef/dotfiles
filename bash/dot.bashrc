# Bash preferences
HISTCONTROL=ignoredups
HISTFILESIZE=2000
HISTSIZE=1000
shopt -s histappend
shopt -s checkwinsize
set +o histexpand

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

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local EXIT="${?}"
    local basecolor="\e[1;32m"
    local delcolor="\e[0;37m"
    local exitchar
    local myhost=$(hostname -f 2>/dev/null || hostname)
    # at work I'd like a different color
    if hostname 2>&1 | grep -qi 'transip' || hostname -f 2>&1 | grep -qi 'transip'; then
        basecolor="\e[1;34m"
    fi
    # root wants another color brackets
    if [ "$(whoami)" = "root" ]; then
        delcolor="\e[1;31m"
    fi
    # reflect exit code
    if [ ${EXIT} -eq 0 ]; then
        exitchar="\e[0;32m✓"
    else
        exitchar="\e[1;31mx"
    fi

    PS1="\[${delcolor}\][${basecolor}\u@${myhost} \W${delcolor}] ${exitchar} ${delcolor}#\[\e[0m\] "
}

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
