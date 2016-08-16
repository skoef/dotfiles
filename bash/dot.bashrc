# Bash preferences
HISTCONTROL=ignoredups
HISTFILESIZE=2000
HISTSIZE=10000
HISTIGNORE="*reboot:*shutdown *:* poweroff:history"
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
[ -d /usr/local/etc/bash_completion.d ] && for __f in /usr/local/etc/bash_completion.d/*; do source ${__f}; done
unset __f

# custom completions
complete -W '$(awk "{print \$1}" .ssh/known_hosts)' ssh
complete -cf sudo

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
__bash_base_color=$__bash_bold_green
__bash_delim_color=$__bash_txt_white
__bash_level_prefix=
__bash_bang_char='$'
__bash_ok_char='v'
__bash_level_char='>'
__bash_pretty_term=0
__bash_update_tty=0

# can we afford a pretty shell
[[ $(tty) =~ /dev/pts/[0-9]+ || $(uname) =~ Darwin ]] && __bash_pretty_term=1

# use different colors at work
[[ ${__bash_my_host} =~ 'transip' ]] && __bash_base_color=$__bash_bold_blue
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

# reflect amount of levels deep we are
[ ${SHLVL} -gt 1 ] && __bash_level_prefix=$(seq $((${SHLVL} - 1)) | xargs -IX echo -n "${__bash_bold_yellow}${__bash_level_char}")" "

function __prompt_command() {
    local exitcode=$? \
          exitchar="${__bash_txt_green}${__bash_ok_char}" \
          cur_host="${__bash_my_host}"

    # reflect exit code
    [ $exitcode -ne 0 ] && exitchar="${__bash_bold_red}x"

    # shorter prompt when screen resolution is low
    [ ${COLUMNS} -le 80 ] && cur_host="${__bash_my_host_short}"

    # set prompt
    PS1="${__bash_delim_color}[${__bash_base_color}\u@${cur_host} \W${__bash_delim_color}$(parse_git_branch_or_tag)] ${__bash_level_prefix}${exitchar} ${__bash_txt_reset}${__bash_bang_char} "
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
