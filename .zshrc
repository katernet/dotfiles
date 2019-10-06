# Paths #
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
typeset -g ZSH=$HOME/.zsh

# Plugins #
plugins=(git git-prompt notify zsh-z zsh-autosuggestions fast-syntax-highlighting)

# Sources #
source "$ZSH"/init.zsh
source "$ZSH"/comp.zsh
source "$ZSH"/prompt.zsh
source "$ZSH"/alias.zsh
