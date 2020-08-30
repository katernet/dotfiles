# Vars
export CLICOLOR=1						# Enable macOS terminal colors
export LSCOLORS='Gxfxcxdxbxegedabagacad'			# Set BSD ls colors
typeset -g DEFAULTUSER=${HOME##*/}				# Get logged in user ID
typeset -g DOCKER_CONFIG=$XDG_CONFIG_HOME/docker 		# Docker config location
typeset -g DOCKER_CERT_PATH=$XDG_DATA_HOME/docker-machine/certs # Docker cert location

# Opt
setopt auto_cd auto_pushd pushdignoredups pushdminus pushdsilent no_case_glob hist_ignore_dups \
	hist_expire_dups_first hist_ignore_space extended_history inc_append_history prompt_subst
# auto_cd : 		  Change directory without cd
# auto_pushd : 		  Set cd to push the old directory onto the directory stack
# pushdignoredups : 	  Don’t push multiple copies of directories onto the directory stack
# pushdminus : 		  Exchange meanings of + and - with a number in the directory stack
# pushdsilent: 		  Don't print the directory stack after pushd or popd
# no_case_glob : 	  Enable case-insensitive globbing
# hist_ignore_dups : 	  Ignore duplicated commands in history
# hist_expire_dups_first: Delete duplicates first when HISTFILE size exceeds HISTSIZE
# hist_ignore_space : 	  Ignore commands that start with space
# extended_history : 	  Record timestamp of command in history
# inc_append_history : 	  Add commands to history in order of execution
# prompt_subst : 	  Allow expansion in prompts
unsetopt flowcontrol histverify
# flowcontrol : 	  Output flow control in the shell’s editor
# histverify :  	  Confirmation in expansion
# Transient right prompt - Used with transient prompt and without rprompt clock & hist line set
[[ -n "$PROMPT_TRANSIENT" ]] && [[ -z "$RPROMPT_CLOCK" && -z "$RPROMPT_HISTLINE" ]] && setopt transient_rprompt

# History
if [ $UID = 0 ]; then
	HISTFILE=$XDG_CACHE_HOME/zsh/.zhistory_$USER.zsh # Hist file for root
	HISTSIZE=1000
	SAVEHIST=1000
elif [ -n "$PROMPT_HISTDISABLE" ]; then
	HISTFILE=/dev/null # Disable history
else
	HISTFILE=$XDG_CACHE_HOME/zsh/.zhistory
	HISTSIZE=50000
	SAVEHIST=10000
fi
[ -z "$PROMPT_HISTOFF" ] && HISTORY_IGNORE='(-|[1-9]|cd|z *|l|l[dtuR@]|d|e|hist|h|top|se|.|..|...*)' || SAVEHIST=0

# Compinit. Limit dump check to once per day and compile for fast load.
# Adapted from https://gist.github.com/ctechols/ca1035271ad134841284
comp() {
	autoload -Uz compinit
	setopt local_options extendedglob # Enable extended globbing for this function only
	local zcd=$XDG_CACHE_HOME/zsh/.zcompdump
	if [[ $UID = 0 || -n $SUDO_USER ]]; then # Root user
		compinit -u -d "$zcd"_$USER # -u: Accept insecure directories
		return
	fi
	if [[ -f "$zcd"(#qN.m+1) || ! -f "$zcd" ]]; then # If dump modified >1 day ago or does not exist
		compinit -d "$zcd"
		zcompile "$zcd" &! # Compile dump in a background job
	else
		compinit -C -d "$zcd" # -C: Ignore checking
		[[ ! -f "$zcd".zwc || "$zcd" -nt "$zcd".zwc ]] && zcompile "$zcd" &! # If no compiled dump or dump newer than compiled dump
	fi
}

# Zinit
declare -A ZINIT
ZINIT[HOME_DIR]=$ZDOTDIR/zinit
ZINIT[PLUGINS_DIR]=$ZDOTDIR/zinit/plugins
ZINIT[COMPLETIONS_DIR]=$ZDOTDIR/zinit/completions
if [ -d ${ZINIT[HOME_DIR]} ]; then
	source ${ZINIT[HOME_DIR]}/zinit.zsh
else # Install Zinit
	typeset -g nomotd=y
	print -P "%F{214}▓▒░ %F{220}Installing Zinit plugin manager…%f"
	(($+commands[git])) || { print -P "%F{214}▓▒░ %F{9}Error: Git is required to install Zinit!%F"; return 1 } # Git not intalled
	command git clone https://github.com/zdharma/zinit.git $ZDOTDIR/zinit && \
		print -P "%F{214}▓▒░ %F{green}Installation successful.%F" || \
			print -P "%F{214}▓▒░ %F{9}Error: The clone has failed!%F"
	source $ZDOTDIR/zinit/zinit.zsh
fi

# Load plugins with Zinit
zinit wait silent light-mode for \
	katernet/git-prompt \
	agkozak/zsh-z \
	atload'zstyle ":notify:*" error-title "zsh: Job failed (#{time_elapsed})"
	zstyle ":notify:*" success-title "zsh: Job finished (#{time_elapsed})"
		zstyle ":notify:*" activate-terminal yes' \
		marzocchi/zsh-notify \
	atinit'comp; zicdreplay' \
		zdharma/fast-syntax-highlighting \
	nocd atload'_zsh_autosuggest_start' \
		zsh-users/zsh-autosuggestions
if (($+commands[svn])); then
	zinit ice svn wait=1 silent light-mode; zinit snippet OMZ::plugins/git
else
	print -P "%F{cyan}▓▒░ %F{9}Error: SVN is required to install git plugin!%F"
fi

# Load thefuck
if (($+commands[thefuck])); then
	fuck() {
		eval $(thefuck --alias) && fuck
	}
fi

# Add python auto venv to chpwd
[ -n "$PROMPT_VENV" ] && chpwd_functions+=(avenv)

# Syntax highlighting
(( ${+FAST_HIGHLIGHT_STYLES} )) || typeset -A FAST_HIGHLIGHT_STYLES # Set styles associative array
FAST_HIGHLIGHT_STYLES[alias]=fg=magenta
FAST_HIGHLIGHT_STYLES[globbing]=fg=99 		# SlateBlue1
FAST_HIGHLIGHT_STYLES[history-expansion]=fg=99
FAST_HIGHLIGHT_STYLES[path]=underline
FAST_HIGHLIGHT_STYLES[path-to-dir]=underline
FAST_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
FAST_HIGHLIGHT_STYLES[single-hyphen-option]=none
FAST_HIGHLIGHT_STYLES[double-hyphen-option]=none
FAST_HIGHLIGHT_STYLES[whatis_chroma_type]=0

# zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1 		# Async suggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1	# Disable auto widget re-binding on each precmd
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
	show_dirs
	accept-line
	bracketed-paste
	copy-earlier-word
	expand-or-complete
	history-search-forward
	history-search-backward
	history-beginning-search-forward
	history-beginning-search-backward
	history-substring-search-up
	history-substring-search-down
	up-line-or-beginning-search
	down-line-or-beginning-search
	up-line-or-history
	down-line-or-history
)

# zsh-z
ZSHZ_OWNER=$DEFAULTUSER # Use zsh-z with sudo
ZSHZ_DATA=$ZDOTDIR/.z
