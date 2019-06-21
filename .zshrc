#!/bin/zsh

# Greeting #
[[ $UID = 501 ]] && uname -mnprs; uptime # Only show greeting for user account

# Paths #
export PATH=/usr/local/bin:$PATH
export ZSH=/Users/$(id -nu 501)/.oh-my-zsh
export ZFILES="$ZSH"/zfiles

# Prompt #
#PS1="%n@%m %F{green}%(5~|%-1~/…/%2~|%4~)%f $(git_prompt_info)%(?.%#.%F{red}%#%f) " # Disabled now in $ZSH/custom/themes/me.zsh-theme

# Theme #
ZSH_THEME="me"

# Plugins #
plugins=(git thefuck zsh-autosuggestions zsh-syntax-highlighting z)

# History #
HISTFILE="$ZFILES"/.zsh_history

# Disable compfix for root user #
[[ $UID = 0 ]] && ZSH_DISABLE_COMPFIX=true # https://github.com/robbyrussell/oh-my-zsh/issues/6939

# Sources #
source "$ZSH"/oh-my-zsh.sh
source "$ZFILES"/.zsh_aliases # Aliases
source "$ZFILES"/.zsh_functions # Functions

# Custom syntax highlighting #
ZSH_HIGHLIGHT_STYLES[globbing]=fg=99 # SlateBlue1
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=99

# Options #
unsetopt histverify # Disable confirmation in expansion

# zfiles #
compinit -i -d "$ZFILES"/zcompdump-$SHORT_HOST-$ZSH_VERSION
_Z_DATA="$ZFILES"/.z
