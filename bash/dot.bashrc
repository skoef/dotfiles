# nice green prompt :)
PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '

# more intelligent Ctrl-W behaviour
stty werase undef
bind '"\C-w": backward-kill-word'

# prefered aliases
alias vi="vim"
