#!/bin/zsh

# Greeting #
[[ $UID = 501 ]] && uname -mnprs && uptime # Only show greeting for user account

# Paths #
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export ZSH=/Users/$(id -nu 501)/.zsh
export GPG_TTY=$(tty) # GPG signing

# Plugins #
plugins=(git thefuck zsh-autosuggestions zsh-syntax-highlighting z)

# Sources #
source "$ZSH"/.zsh_prompt
source "$ZSH"/.zsh_completion
source "$ZSH"/.zsh_aliases
source "$ZSH"/.zsh_functions
source "$ZSH"/.zsh_options

# Custom syntax highlighting #
ZSH_HIGHLIGHT_STYLES[globbing]=fg=99 # SlateBlue1
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=99
zle_highlight+=(paste:none) # Disable paste highlighting

# z files #
HISTFILE="$ZSH"/.zsh_history
_Z_DATA="$ZSH"/.z
