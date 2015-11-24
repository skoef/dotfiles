# Bash preferences
HISTCONTROL=ignoredups
HISTFILESIZE=2000
HISTSIZE=1000
HISTIGNORE="reboot:shutdown *:history"
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

__bash_bold_green='\[\e[1;32m\]'
__bash_bold_blue='\[\e[1;34m\]'
__bash_bold_red='\[\e[1;31m\]'
__bash_bold_yellow='\[\e[1;33m\]'
__bash_txt_green='\[\e[0;32m\]'
__bash_txt_white='\[\e[0;37m\]'
__bash_txt_reset='\[\e[0m\]'

function __prompt_command() {
    local exitcode=$? \
          myhost=$(hostname -f 2>/dev/null || hostname) \
          basecolor=$__bash_bold_green \
          delcolor=$__bash_txt_white \
          bang='$' \
          exitchar lvlprefix okchar lvlchar

    # plain or utf8 chars
    if [[ $(tty) =~ /dev/pts/[0-9]+ ]]; then
        okchar=$'\xe2\x9c\x93\0a'
        lvlchar=$'\xc2\xbb'
    else
        okchar="v"
        lvlchar=">"
    fi

    # when in subshell, show prefix
    [ ${SHLVL} -gt 1 ] && lvlprefix=$(seq $((${SHLVL} - 1)) | xargs -IX echo -n "${__bash_bold_yellow}${lvlchar}")" "

    # at work I'd like a different color
    if [[ $(hostname -f 2>&1 || hostname 2>&1) =~ 'transip' ]]; then
        basecolor=$__bash_bold_blue
    fi
    # root wants another color brackets
    if [ "$(whoami)" = "root" ]; then
        delcolor=$__bash_bold_red
        bang='#'
    fi
    # reflect exit code
    if [ $exitcode -ne 0 ]; then
        exitchar="${__bash_bold_red}x"
    else
        exitchar="${__bash_txt_green}${okchar}"
    fi

    PS1="${delcolor}[${basecolor}\u@${myhost} \W${delcolor}] ${lvlprefix}${exitchar} ${__bash_txt_reset}${bang} "
}

# prefer vim over vi
if [ ! -z "$(which vim)" -a -x "$(which vim)" ]
then
    alias vi="vim"
fi

# always keep environment when user sudo
alias sudo="sudo -E"
# I like solarized for mutt, so set TERM to make it work
alias mutt="TERM=xterm-256color mutt"

# run python script on startup python interactive mode
# in my case this script takes care of my history when using interactive mode
if [ -r ${HOME}/.pystartup ]
then
    PYTHONSTARTUP=${HOME}/.pystartup; export PYTHONSTARTUP
fi
