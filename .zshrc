# Paths #
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
typeset -g ZSH=$HOME/.zsh

# Plugins #
plugins=(git git-prompt notify zsh-z zsh-autosuggestions fast-syntax-highlighting)

# Sources #
source "$ZSH"/.zsh_init
source "$ZSH"/.zsh_comp
source "$ZSH"/.zsh_prompt
source "$ZSH"/.zsh_alias
