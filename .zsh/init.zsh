# Vars
typeset -U PATH					# Fix path appends
typeset -g DEFAULTUSER=${HOME##*/}		# Logged in user
export GPG_TTY=$TTY				# GPG signing
export CLICOLOR=1				# Enable terminal colors
export LSCOLORS="Gxfxcxdxbxegedabagacad" 	# ls colors
typeset -g LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43" # GNU ls colors
# Prompt options - To disable an option remove 'y'
typeset -g PROMPT_GIT=y 			# Prompt git status
typeset -g PROMPT_VENV=y			# Prompt virtual environment
typeset -g PROMPT_MOTD=y			# Prompt message of the day
typeset -g PROMPT_RJOB=y			# Prompt random job
typeset -g RPROMPT_ON=y				# Right prompt
typeset -g RPROMPT_CLOCK=y			# Right prompt 24H clock
typeset -g RPROMPT_CLOCKTICK=y			# Right prompt ticking clock
typeset -g RPROMPT_CMDTIME=y 			# Right prompt command time
typeset -g RPROMPT_HISTORY=y			# Right prompt history line
typeset -g RPROMPT_RETURN=y 			# Right prompt return code
typeset -g RPROMPT_RETURNSIG=y			# Right prompt return signal

# Opt
setopt always_to_end 		# Cursor placed at end after completion
setopt auto_cd 			# Change directory without cd
setopt auto_menu 		# Show completion menu on successive tab press
setopt auto_pushd 		# Make cd push the old directory onto the directory stack
setopt pushdignoredups 		# Don’t push multiple copies of the same directory onto the directory stack
setopt pushdminus 		# Exchanges meanings of + and - with a number specified directory in the stack
setopt complete_in_word 	# Allow completion from within a word/phrase
setopt globdots			# Dotfiles are matched without explicitly specifying the dot
setopt hist_expire_dups_first 	# Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups 	# Ignore duplicated commands history list
setopt hist_ignore_space 	# Ignore commands that start with space
setopt extended_history		# Record timestamp of command in HISTFILE
setopt inc_append_history 	# Add commands to HISTFILE in order of execution
setopt interactive_comments 	# Allow comments even in interactive shells
setopt prompt_subst 		# Allow expansion in prompts
unsetopt flowcontrol 		# Disable output flow control in the shell’s editor
unsetopt histverify 		# Disable confirmation in expansion
unsetopt list_beep		# Turn off completion list beeps

# Keybinds
bindkey '^[[3~'		delete-char 			# [Del]  - Forward delete
bindkey '^[[H'		beginning-of-line 		# [Home] - Beginning of line
bindkey '^[[F'		end-of-line 			# [End]  - End of line
bindkey '^[[A'		up-line-or-beginning-search 	# [Up]   - History search up
bindkey '^[[B'		down-line-or-beginning-search 	# [Down] - History search down

# History
HISTFILE="$ZSH"/.zsh_hist
HISTORY_IGNORE='(cd|l|ld|lt|d|exit|hist|h|zsht|.|..|...|....|.....)'
HISTSIZE=50000
SAVEHIST=10000

# zplugin
declare -A ZPLGM
ZPLGM[HOME_DIR]="$ZSH"/zplugin
ZPLGM[PLUGINS_DIR]="$ZSH"/zplugin/plugins
ZPLGM[COMPLETIONS_DIR]="$ZSH"/zplugin/completions

# Load plugins with zplugin
source ${ZPLGM[HOME_DIR]}/zplugin.zsh
for p ($plugins); do
	if [ -e "$ZSH"/plugins/$p/$p.plugin.zsh ]; then
		if [ $p = "zsh-autosuggestions" ]; then
			zplugin ice lucid nocd wait'' atload'_zsh_autosuggest_start' # Required for suggestions to work on login
			zplugin light "$ZSH"/plugins/$p
		else
			zplugin ice lucid wait'' $p
			zplugin light "$ZSH"/plugins/$p
		fi
	fi
done

# compinit
# Load dump only once per day and compile for fast load https://gist.github.com/ctechols/ca1035271ad134841284
() {
	autoload -Uz compinit
	setopt localoptions extendedglob # Enable globbing patterns for this function only
	local zcd="$ZSH"/.zcompdump
	local zcdc="$zcd.zwc"
	if [[ $UID = 0 || -n $SUDO_USER ]]; then # Root user
		compinit -i -d "$zcd"_$USER # Dump for root user -i: Ignore insecure files
		return
	fi
	if [[ -f "$zcd"(#qN.m+1) || ! -f "$zcd" ]]; then # If dump modified >1 day ago or doesn't exist
		compinit -d "$zcd" # -d: Custom dump path
		{ zcompile "$zcd" } &| # Compile dump in background job
	else
		compinit -C -d "$zcd" # -C: Ignore checking
		{ [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && zcompile "$zcd" } &| # If no compiled dump or dump newer than compiled dump
	fi
}

# fpath functions
fpath+="$ZSH"/functions
autoload -Uz _funcs _shrinkpath && _funcs

# Custom syntax highlighting
typeset -gA FAST_HIGHLIGHT_STYLES # Prevent style assignment to invalid subscript range
FAST_HIGHLIGHT_STYLES[alias]=fg=magenta
FAST_HIGHLIGHT_STYLES[globbing]=fg=99 		# SlateBlue1
FAST_HIGHLIGHT_STYLES[history-expansion]=fg=99
FAST_HIGHLIGHT_STYLES[path]=underline
FAST_HIGHLIGHT_STYLES[path-to-dir]=underline
FAST_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
FAST_HIGHLIGHT_STYLES[single-hyphen-option]=none
FAST_HIGHLIGHT_STYLES[double-hyphen-option]=none

# zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
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

# zsh-z
ZSHZ_OWNER="$DEFAULTUSER" # Use zsh-z with sudo
ZSHZ_DATA="$ZSH"/.z
