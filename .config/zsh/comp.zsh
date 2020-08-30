# Opt
setopt always_to_end auto_menu complete_in_word globdots
# always_to_end :    Cursor placed at end after completion
# auto_menu : 	     Show completion menu on successive tab press
# complete_in_word : Allow completion from within a word/phrase
# globdots :  	     Dotfiles are matched in completions without specifying the dot
unsetopt list_beep # Turn off completion list beeps

# Load functions
autoload -Uz bracketed-paste-magic url-quote-magic

# Menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Lists
zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''
# Directories
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors 'di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*:directory-stack' menu yes select
# Processes
zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# Cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $XDG_CACHE_HOME/zstylecache

# Bracketed paste magic
zle -N bracketed-paste bracketed-paste-magic

# Accept completion on first enter key press
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line

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
