stty werase undef
bind '"\C-w": backward-kill-word'

# define prompt colors
# use another color on hosts from my employer
if hostname | grep -qi 'transip'
then
	basecolor="\e[1;34m"
else
	basecolor="\e[1;32m"
fi

# format prompt, based on uid
if [ "$(whoami)" = "root" ]
then
	PS1="\[\e[1;31m\][${basecolor}\u@\H \W\e[1;31m]#\[\e[0m\] "
else
	PS1="\[${basecolor}\][\u@\H \W]\\$\[\e[0m\] "
fi

# aliases
if [ ! -z "$(which vim)" -a -x "$(which vim)" ]
then
	alias vi="vim"
fi
