# Bash preferences
HISTCONTROL=ignoredups
HISTFILESIZE=10000
HISTSIZE=100000
HISTIGNORE="*reboot:*shutdown *:* poweroff:history"
HISTTIMEFORMAT='%F %T '
# Append to the history file, don't overwrite it
shopt -s histappend 2>/dev/null
set +o histexpand
# Update window size after every command
shopt -s checkwinsize 2>/dev/null

# Correct spelling errors during tab-completion
shopt -s dirspell 2>/dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2>/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -z "$PS1" ] && return

# replace unix-word-rubout with backward-kill-word
if [ ! -z "${TERM}" ] && [ "${TERM}" != "dumb" ]
then
    stty werase undef
    bind '"\C-w": backward-kill-word'
fi

# custom completions
complete -W '$([ -f .ssh/known_hosts ] && awk "{print \$1}" .ssh/known_hosts | awk -F"," "{print \$1}")' ssh

# define color vars
__bash_bold_green='\[\e[1;32m\]'
__bash_bold_blue='\[\e[1;34m\]'
__bash_bold_red='\[\e[1;31m\]'
__bash_bold_yellow='\[\e[1;33m\]'
__bash_txt_green='\[\e[0;32m\]'
__bash_txt_white='\[\e[0;37m\]'
__bash_txt_reset='\[\e[0m\]'

# set prompt defaults
__bash_my_host=$(hostname -f 2>/dev/null || hostname)
__bash_my_host_short=$(echo $__bash_my_host | sed 's/\(\.[a-z]\{1,\}\)\{2\}$//')
__bash_delim_color=$__bash_txt_white
__bash_bang_char='$'
__bash_ok_char='v'
__bash_level_char='>'
__bash_pretty_term=0
__bash_update_tty=0

# can we afford a pretty shell
[[ $(tty) =~ /dev/pts/[0-9]+ || $(uname) =~ Darwin ]] && __bash_pretty_term=1

# use slightly different prompt when operating as root
if [ "$(whoami)" = "root" ]; then
    __bash_delim_color=$__bash_bold_red
    __bash_bang_char='#'
fi
# use UTF8 chars when available
if [ ${__bash_pretty_term} -eq 1 ]; then
    __bash_ok_char=$'\xe2\x9c\x93\0a'
    __bash_level_char=$'\xc2\xbb'
    __bash_update_tty=1
    # also, make term prettier
    [ ${TERM} = "xterm" ] && TERM="xterm-256color" && export TERM
fi

# use different colors at work
__bash_base_color=$__bash_bold_green
__bash_path_color=$__bash_bold_blue
if [[ ${__bash_my_host} =~ 'transip' ]]; then
    __bash_base_color=$__bash_bold_blue
    __bash_path_color=$__bash_bold_green
fi

function __prompt_command() {
    local exitcode=$? \
          exitchar="${__bash_txt_green}${__bash_ok_char}" \
          cur_host="\H"

    # reflect exit code
    [ $exitcode -ne 0 ] && exitchar="${__bash_bold_red}x"

    # shorter prompt when screen resolution is low
    [ ${COLUMNS} -le 80 ] && cur_host="\h"

    # set prompt
    PS1="${__bash_delim_color}[${__bash_base_color}\u@${cur_host} ${__bash_path_color}\W${__bash_delim_color}$(parse_git_branch_or_tag)] ${exitchar} ${__bash_txt_reset}${__bash_bang_char} "
}
export PROMPT_COMMAND=__prompt_command

parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_git_tag () {
  git describe --tags 2> /dev/null
}

parse_git_branch_or_tag() {
  local OUT="$(parse_git_branch)"
  [ "${OUT}" == " ((no branch))" ] && OUT="($(parse_git_tag))"
  [ -z "${OUT}" ] && return
  echo "${__bash_txt_green}${OUT}${__bash_delim_color}"
}

# update window title
[ $__bash_update_tty -eq 1 ] &&  [ -z "${TMUX_PANE}" ] && echo -n -e '\033k'${__bash_my_host_short}'\033\\'

# prefer vim over vi
[ ! -z "$(which vim 2>/dev/null)" ] && alias vi="vim"

# run python script on startup python interactive mode
# in my case this script takes care of my history when using interactive mode
if [ -r ${HOME}/.pystartup ]
then
    PYTHONSTARTUP=${HOME}/.pystartup; export PYTHONSTARTUP
fi

# detect tmux, but only when not already in tmux
if [ ! -z "$(which tmux 2>/dev/null)" ] && [ -z "${TMUX}" ] && [[ ${__bash_my_host} =~ 'skoef' ]]; then
    # detect if the default session exists
    if tmux has-session -t "default-${__bash_my_host_short}" 2>/dev/null; then
        exec tmux attach-session -d -t "default-${__bash_my_host_short}"
    else
        exec tmux new-session -s "default-${__bash_my_host_short}" "echo; cat /etc/motd; bash"
    fi
fi
