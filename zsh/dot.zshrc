# Personal profile for interactive zsh(1) shells.
# based on MacOS Catalina default profile

# Correctly display UTF-8 with combining characters.
if [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
    setopt COMBINING_CHARS
fi

# Disable the log builtin, so we don't conflict with /usr/bin/log
disable log

# Save command history
setopt EXTENDED_HISTORY
#setopt SHARE_HISTORY
setopt APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=1000

# Ctrl-W deletes to first /
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^w' backward-kill-dir

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' (%F{green}%b%f)'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# Beep on error
setopt BEEP

# Use keycodes (generated via zkbd) if present, otherwise fallback on
# values from terminfo
if [[ -r ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR} ]] ; then
    source ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}
else
    typeset -g -A key

    [[ -n "$terminfo[kf1]" ]] && key[F1]=$terminfo[kf1]
    [[ -n "$terminfo[kf2]" ]] && key[F2]=$terminfo[kf2]
    [[ -n "$terminfo[kf3]" ]] && key[F3]=$terminfo[kf3]
    [[ -n "$terminfo[kf4]" ]] && key[F4]=$terminfo[kf4]
    [[ -n "$terminfo[kf5]" ]] && key[F5]=$terminfo[kf5]
    [[ -n "$terminfo[kf6]" ]] && key[F6]=$terminfo[kf6]
    [[ -n "$terminfo[kf7]" ]] && key[F7]=$terminfo[kf7]
    [[ -n "$terminfo[kf8]" ]] && key[F8]=$terminfo[kf8]
    [[ -n "$terminfo[kf9]" ]] && key[F9]=$terminfo[kf9]
    [[ -n "$terminfo[kf10]" ]] && key[F10]=$terminfo[kf10]
    [[ -n "$terminfo[kf11]" ]] && key[F11]=$terminfo[kf11]
    [[ -n "$terminfo[kf12]" ]] && key[F12]=$terminfo[kf12]
    [[ -n "$terminfo[kf13]" ]] && key[F13]=$terminfo[kf13]
    [[ -n "$terminfo[kf14]" ]] && key[F14]=$terminfo[kf14]
    [[ -n "$terminfo[kf15]" ]] && key[F15]=$terminfo[kf15]
    [[ -n "$terminfo[kf16]" ]] && key[F16]=$terminfo[kf16]
    [[ -n "$terminfo[kf17]" ]] && key[F17]=$terminfo[kf17]
    [[ -n "$terminfo[kf18]" ]] && key[F18]=$terminfo[kf18]
    [[ -n "$terminfo[kf19]" ]] && key[F19]=$terminfo[kf19]
    [[ -n "$terminfo[kf20]" ]] && key[F20]=$terminfo[kf20]
    [[ -n "$terminfo[kbs]" ]] && key[Backspace]=$terminfo[kbs]
    [[ -n "$terminfo[kich1]" ]] && key[Insert]=$terminfo[kich1]
    [[ -n "$terminfo[kdch1]" ]] && key[Delete]=$terminfo[kdch1]
    [[ -n "$terminfo[khome]" ]] && key[Home]=$terminfo[khome]
    [[ -n "$terminfo[kend]" ]] && key[End]=$terminfo[kend]
    [[ -n "$terminfo[kpp]" ]] && key[PageUp]=$terminfo[kpp]
    [[ -n "$terminfo[knp]" ]] && key[PageDown]=$terminfo[knp]
    [[ -n "$terminfo[kcuu1]" ]] && key[Up]=$terminfo[kcuu1]
    [[ -n "$terminfo[kcub1]" ]] && key[Left]=$terminfo[kcub1]
    [[ -n "$terminfo[kcud1]" ]] && key[Down]=$terminfo[kcud1]
    [[ -n "$terminfo[kcuf1]" ]] && key[Right]=$terminfo[kcuf1]
fi

# Default key bindings
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search

# Custom key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Styled prompt
if [[ $(hostname -f 2>/dev/null || hostname) =~ transip ]]; then
  local _prompt_color_host=blue
  local _prompt_color_path=gree
else
  local _prompt_color_host=green
  local _prompt_color_path=blue
fi
PROMPT=" [%B%F{\${_prompt_color_host}}%n@%m%f%b %B%F{\${_prompt_color_path}}%1~%f%b\${vcs_info_msg_0_}] %# "

# Useful support for interacting with Terminal.app or other terminal programs
[ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"
[ -r ~/.iterm2_shell_integration.zsh ] && . ~/.iterm2_shell_integration.zsh
