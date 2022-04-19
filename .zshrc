# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE="$HOME/.zsh_history"

autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
setopt nocasematch
setopt nocaseglob
setopt null_glob
setopt hist_ignore_all_dups

# Basic word modification bindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '\e[3;5~' kill-word
bindkey '\C-h' backward-kill-word

# BInd Ctrl+S to go back to bash...
bindkey -s '^S' '\C-uexit\n'

bindkey -s '^R' '\C-usearch-history\n'

# Ctrl+O for dropping into vim...
bindkey -s '^O' "\C-uvim .\n"


bindkey '^N' down-history
bindkey '^P' up-history

# Common shell configs
source "$HOME/.shell-config"
# ZSH specific completions
source "$HOME/.zsh-completions"

if [ "$color_prompt" = yes ]; then
    autoload -U colors && colors
    PS1="%{$fg[blue]%}(zsh)%{$fg[cyan]%} %~% %{$fg[green]%} 🠖 %{$reset_color%}"
else
    PS1='(zsh) %~% > '
fi
unset color_prompt

# Edit & Update the .zshrc
alias zrc='$EDITOR $HOME/.zshrc && source $HOME/.zshrc'

# Load plugins
# Location of these plugins may vary,
# run: 'find /usr/share -iname zsh-*.zsh' to find them.
# These should be loaded in the end of the script...
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# For accepting autosuggestions
bindkey '^L' forward-char

