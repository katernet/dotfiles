# Paths #
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export ZSH=/Users/$(id -nu 501)/.zsh

# Plugins #
plugins=(git myfunc thefuck z zsh-autosuggestions zsh-syntax-highlighting)

# Sources #
source "$ZSH"/.zsh_init
source "$ZSH"/.zsh_comp
source "$ZSH"/.zsh_prompt
source "$ZSH"/.zsh_alias
