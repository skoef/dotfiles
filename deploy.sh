#!/bin/sh

FORCE=0
while getopts "f" opt; do
    case ${opt} in
        f) FORCE=1;;
    esac
done

MYDIR=$(dirname ${0})
find ${MYDIR} -type f -name 'dot.*' | while read DOTFILE; do
    TARGET=$(echo ${DOTFILE} | awk -F'/' '{print $NF}' | sed "s/^dot\./~\/./")
    [ ${FORCE} -eq 1 ] && CMD="-sf" || CMD="-s"
    eval ln ${CMD} ${DOTFILE} ${TARGET}
done

# fix for vim color scheme that is multiple levels deep
rm ~/.vim__colors__dracula.vim
mkdir -p ~/.vim/colors
ln -s ../../dotfiles/vim/dot.vim__colors__dracula.vim .vim/colors/dracula.vim
