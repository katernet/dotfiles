autoload -Uz bracketed-paste-magic edit-command-line url-quote-magic up-line-or-beginning-search down-line-or-beginning-search

# Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true # Complete . and .. special directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Processes
zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# Disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# Cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$ZSH"/.zstylecache
# zsh-notify
zstyle ':notify:*' error-title "zsh: Job failed (#{time_elapsed}s)"
zstyle ':notify:*' success-title "zsh: Job finished (#{time_elapsed}s)"
zstyle ':notify:*' activate-terminal yes

# Bracketed paste magic
zle -N bracketed-paste bracketed-paste-magic

# Speed up pasting w/ autosuggest
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
