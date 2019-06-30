# Paths #
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export ZSH=/Users/$(id -nu 501)/.zsh

# Plugins #
plugins=(git thefuck zsh-autosuggestions zsh-syntax-highlighting z)

# Sources #
source "$ZSH"/.zsh_completion
source "$ZSH"/.zsh_functions
source "$ZSH"/.zsh_options
source "$ZSH"/.zsh_prompt
source "$ZSH"/.zsh_aliases
