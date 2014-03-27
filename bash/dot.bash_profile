# Startup file for login instances of the bash(1) shell.

# locale
export CHARMAP="UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG=en_US.UTF-8

# colors
export TERM="xterm"
export CLICOLOR=1
export LSCOLORS="Exfxcxdxbxegedabagacad"
# for linux
export LS_COLORS="di=1;;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

# set timezone
if [ -r /etc/timezone ]; then
    TZ=$(cat /etc/timezone); export TZ
fi

# compose path
PATH="~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
[ -d /usr/local/adm/bin ] && PATH="${PATH}:/usr/local/adm/bin"
[ -d /usr/local/php/tools ] && PATH="${PATH}:/usr/local/php/tools"
# solaris/openindiana specific paths
[ -d /usr/gnu/bin/ ] && PATH="/usr/gnu/bin/:${PATH}"
[ -d /opt/csw/bin ] && PATH="${PATH}:/opt/csw/bin"
export PATH

# prefer vim over vi
[ -x /usr/local/bin/vim ] && EDITOR="/usr/local/bin/vim"
[ -x /usr/bin/vim ] && EDITOR="/usr/bin/vim"
export EDITOR

# run a .bashrc file if it exists.
[ -f ${HOME}/.bashrc ] && source ${HOME}/.bashrc
