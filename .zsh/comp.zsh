autoload -Uz bracketed-paste-magic edit-command-line url-quote-magic up-line-or-beginning-search down-line-or-beginning-search

# Menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Directories
zstyle ':completion:*:default' list-colors 'di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*:directory-stack' menu yes select
# Processes
zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# Cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME"/.cache/zstylecache
# zsh-notify
zstyle ':notify:*' error-title "zsh: Job failed (#{time_elapsed}s)"
zstyle ':notify:*' success-title "zsh: Job finished (#{time_elapsed}s)"
zstyle ':notify:*' activate-terminal yes

# Bracketed paste magic
zle -N bracketed-paste bracketed-paste-magic

# Speed up pasting w/ autosuggest - https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
  typeset -g paste=true # Set paste for prompt sched
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# History search with arrow keys
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
