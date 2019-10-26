# Paths #
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
typeset -g ZSH=$HOME/.zsh

# Plugins #
plugins=(git git-prompt notify zsh-z fast-syntax-highlighting zsh-autosuggestions)

# Sources #
source "$ZSH"/init.zsh
source "$ZSH"/comp.zsh
source "$ZSH"/prompt.zsh
source "$ZSH"/alias.zsh
