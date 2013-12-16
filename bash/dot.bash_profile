# Startup file for login instances of the bash(1) shell.

# locale
export CHARMAP="UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG=en_US.UTF-8

# compose path
PATH="~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
[ -d /usr/local/adm/bin ] && PATH="${PATH}:/usr/local/adm/bin"
[ -d /usr/local/php/tools ] && PATH="${PATH}:/usr/local/php/tools"
export PATH

# prefer vim over vi
export EDITOR=vim

# run a .bashrc file if it exists.
[ -f ${HOME}/.bashrc ] && source ${HOME}/.bashrc
