# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Config bash history
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000
export HISTFILESIZE=1000

HISTFILE="$HOME/.bash_history"

# Shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s nocaseglob
shopt -s expand_aliases

# Common shell configs
source "$HOME/.shell-config"
# Bash completions
source "$HOME/.bash-completions"

if [ "$color_prompt" = "yes" ]; then
    PS1=$'\[\033[0;36m\] \w$(prompt_git_branch)\[\033[0;92m\] 🠖 \[\033[00m\]'
else
    PS1=' \w > '
fi
unset color_prompt

# Edit & Update the .bashrc
alias brc='$EDITOR $HOME/.bashrc && source $HOME/.bashrc'

# Disable Ctrl+S freeze and jump to zsh
stty -ixon
bind '"\C-s":"\C-u/usr/bin/zsh\n"'

# Ctrl+O for dropping into vim...
bind '"\C-o":"\C-uvim .\n"'

bind '"\C-r":"\C-usearch-history\n"'


