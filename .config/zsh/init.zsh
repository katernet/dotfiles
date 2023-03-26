# Path
typeset -U path
export path=(/usr/local/{bin,sbin} $path)

# Env
export EDITOR=${${commands[micro]:t}:-nano}			# Text editor
export VISUAL=$EDITOR						# Visual editor
export GPG_TTY=$TTY						# Set GnuPG TTY
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg				# GnuPG config path
export MACHINE_STORAGE_PATH=$XDG_DATA_HOME/docker-machine	# Docker machine path
export FZF_DEFAULT_OPTS='-1 --reverse --height=11 --no-info'	# Fzf custom options
[ -f $XDG_CONFIG_HOME/git/config ] && \
export GIT_CONFIG=$XDG_CONFIG_HOME/git/config			# Git config path
(($+commands[brew])) && \
export HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1	# Homebrew options

# Vars
typeset -g DEFAULTUSER=${HOME##*/}                              # Logged in user ID
typeset -g DOCKER_CONFIG=$XDG_CONFIG_HOME/docker                # Docker config location
typeset -g DOCKER_CERT_PATH=$XDG_DATA_HOME/docker-machine/certs # Docker cert location

# Opt
setopt auto_cd cd_silent auto_pushd pushd_silent pushd_ignore_dups prompt_subst \
	extended_history hist_ignore_dups hist_ignore_all_dups hist_save_no_dups hist_ignore_space
[ "$PROMPT_TRANSIENT" ] && [[ -z "$RPROMPT_CLOCK" && -z "$RPROMPT_HISTLINE" ]] && setopt transient_rprompt
unsetopt beep case_glob flow_control

# History
HISTSIZE=10000
SAVEHIST=100000
if [ $USER != "$DEFAULTUSER" ]; then
	HISTFILE=$XDG_CACHE_HOME/zsh/zhist_$USER
else
	HISTFILE=$XDG_CACHE_HOME/zsh/zhist
	HISTORY_IGNORE='(-|[1-9]|cd|cdf|z|z *|pwd|l|l[dtuR@]|[bf]g|d|e|h|hist|top|fe|fe *|..|...*)'
fi
# Exclude commands not found from history
zshaddhistory() {
	if [[ $1 != ${~HISTORY_IGNORE} ]]; then # Reintroduce ignored history
		whence ${${(z)1}[1]} >| /dev/null || return 1
	fi
}

# Functions
fpath=($ZDOTDIR/fns $fpath)
autoload -Uz $ZDOTDIR/fns/*(.:t) # Load all functions
if [[ "$OSTYPE" = darwin* ]]; then # Mac fns
	fpath=($ZDOTDIR/macos/fns $fpath)
	autoload -Uz $ZDOTDIR/macos/fns/*(.:t)
fi

# Dirstack
DIRSTACKSIZE=21
DIRSTACKFILE=$XDG_CACHE_HOME/zsh/zdirs
if [[ -f "$DIRSTACKFILE" && $#dirstack -eq 0 ]]; then
	dirstack=(${(f)"$(<$DIRSTACKFILE)"}) # f - split at new lines
	[[ "$PROMPT_DIRRESUME" && $dirstack[1] ]] && popd 2> /dev/null # Go to first dir in stack on login
fi
chpwd() { # Add to dir stack on dir change
	print -l $PWD ${(u)dirstack} > "$DIRSTACKFILE"
}

# Zsh run-help
if ((!${+functions[run-help]})); then
	[ -d /usr/share/zsh/help ] 	 && HELPDIR=/usr/share/zsh/help
	[ -d /usr/local/share/zsh/help ] && HELPDIR=/usr/local/share/zsh/help
	autoload -Uz run-help
	((${+aliases[run-help]})) && unalias run-help # https://wiki.archlinux.org/title/Zsh#Help_command
fi

# Syntax highlight opt
(( ${+FAST_HIGHLIGHT_STYLES} )) || typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[alias]=fg=magenta
FAST_HIGHLIGHT_STYLES[globbing]=fg=99 		# SlateBlue1
FAST_HIGHLIGHT_STYLES[history-expansion]=fg=99
FAST_HIGHLIGHT_STYLES[path]=underline
FAST_HIGHLIGHT_STYLES[path-to-dir]=underline
FAST_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
FAST_HIGHLIGHT_STYLES[single-hyphen-option]=none
FAST_HIGHLIGHT_STYLES[double-hyphen-option]=none
FAST_HIGHLIGHT_STYLES[whatis_chroma_type]=0

# Autosuggest opt
ZSH_AUTOSUGGEST_USE_ASYNC=1 	# Async suggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1	# Disable auto widget rebind
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
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

# Cache
[ ! -d $XDG_CACHE_HOME/zsh ] && mkdir $XDG_CACHE_HOME/zsh
FAST_WORK_DIR=$XDG_CACHE_HOME/zsh # Fast syntax highlight
