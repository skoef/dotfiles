export ZSH="$HOME/.oh-my-zsh"

plugins=(iterm2 kube-ps1 zoxide)

source $ZSH/oh-my-zsh.sh

# tweak history settings
# append to history file right away
setopt APPEND_HISTORY
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

HISTSIZE=100000
SAVEHIST=100000

# revert some aliases
unalias ls
unalias grep

# add some aliases
alias assume=". assume"
alias gitb="git checkout \$(git branch | sort | fzf)"
alias terraform=tofu

# configure git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%})"

# configure kube-ps1 plugin
KUBE_PS1_CTX_COLOR=cyan
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_PREFIX=" ("

# add some additional paths to the PATH
[ -d /opt/homebrew/sbin ] && export PATH="/opt/homebrew/sbin:${PATH}"
[ -d ${HOME}/bin ] && export PATH="${HOME}/bin:${PATH}"
[ -d ${HOME}/go/bin ] && export PATH="${HOME}/go/bin:${PATH}"
[ -d ${HOME}/.krew/bin ] && export PATH="${HOME}/.krew/bin:${PATH}"

# add homebrew managed autocompletions
# this is borrowed from the oh-my-zsh brew plugin but I didn't want all the aliases
if [[ -d "$(brew --prefix)/share/zsh/site-functions" ]]; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi
# enable autocompletion
autoload -Uz compinit; compinit

# set prompt
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$reset_color%}[%{$fg_bold[blue]%}%c%{$reset_color%}\$(git_prompt_info)\$(kube_ps1)] %% "


