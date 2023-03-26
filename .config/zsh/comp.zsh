# Opt
setopt always_to_end auto_menu complete_in_word glob_dots

# Function load
autoload -Uz compinit bracketed-paste-magic url-quote-magic

# Compinit
# Limit comp check to once per day
local zcd check
zcd=$XDG_CACHE_HOME/zsh/zcompdump
# Check date modified time of dump
for i in "$zcd"(N.mh+24); do # Modified over 24 hrs ago
	check='y'
	touch "$zcd"
done
# Call compinit
# -C : Skip check for new comps
[ $check ] && compinit -d "$zcd" || compinit -C -d "$zcd"

# Menu
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# Directories
zstyle ':completion:*' special-dirs true
[[ "$OSTYPE" = darwin* ]] && zstyle ':completion:*' list-colors 'di=1;34:ln=1;36:so=1;31:pi=1;33:ex=1;32:bd=1;34;46:cd=1;34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43' \
	|| { eval "$(dircolors -b)" && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" }
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directorie
zstyle ':completion:*:cd:*:directory-stack' menu yes select
# Processes
zstyle ':completion:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Cache
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
# Speed up pasting w/ autosuggest - https://github.com/zsh-users/zsh-autosuggestions/issues/238
zstyle ':bracketed-paste-magic' active-widgets '.self-*'
zstyle ':bracketed-paste-magic' paste-init pasteinit

# Bracketed paste magic
zle -N bracketed-paste bracketed-paste-magic

# Accept completion on first enter key press
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line

# Set paste for prompt sched
pasteinit() { typeset -g paste=true }
