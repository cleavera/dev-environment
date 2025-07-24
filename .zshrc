export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ls="ls -a"

eval "$(starship init zsh)"

if [ "$TMUX" = "" ]; then tmux; fi
