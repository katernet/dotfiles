# Prompt theme
# Adapted from agnoster https://github.com/agnoster/agnoster-zsh-theme and spaceship-prompt https://github.com/denysdovhan/spaceship-prompt

# Begin a section
# If foreground argument is omitted, renders default foreground.
prompt_section() {
	local fg
	[ "$1" ] && fg="%F{$1}" || fg="%f"
	[ "$PROMPT_BOLD" ] && print -n "%B"
	if [[ "$3" && "$PROMPT_PREFIX" ]]; then
		[ "$3" = "dir" ] && print -n "%F{default}in %f"
		[ "$3" = "docker" ] && print -n "%F{default}on %f"
		[ "$3" = "git" ] && print -n "%F{default}on %f"
		[ "$3" = "os" ] && print -n "%F{default}on %f"
	fi
	print -n "%{$fg%}"
	[ "$2" ] && print -n "$2 "
	[[ "$PROMPT_PREFIX" && "$3" == "context" ]] && print -n "%F{default}at %f"
	[ "$PROMPT_BOLD" ] && print -n "%b"
}

# Begin an rprompt section
prompt_rsection() {
	local fg
	[ "$1" ] && fg="%F{$1}" || fg="%f"
	[ "$PROMPT_BOLD" ] && print -n "%B"
	if [[ "$3" && "$PROMPT_PREFIX" ]]; then
		[ "$3" = "docker" ] && print -n "%F{default} on%f"
		[ "$3" = "git" ] && print -n "%F{default} on%f"
	fi
	print -n "%{$fg%}"
	[ "$2" ] && print -n " $2"
	[ "$PROMPT_BOLD" ] && print -n "%b"
}

# End the prompt closing open sections and set the prompt symbol
prompt_end() {
	[ -z "$PROMPT_CHARCOLOR" ] && local PROMPT_CHARCOLOR=default
	if [ $SHLVL -gt 1 ]; then # Subshell level
		local L
		[ "$PROMPT_CHAR" ] && lvlicon="$PROMPT_CHAR" || lvlicon=">"
		for i in {1..$SHLVL}; do
			L+="$lvlicon"
		done
		[ $i -gt 4 ] && L="$i${lvlicon}"
		PROMPT_SYMBOL="%(!.# .$L )"
	elif [[ "$PROMPT_ICONS" && "$incognito" && "$ghostmode" ]]; then # Incognito ghost mode
		PROMPT_SYMBOL="$ghosticon"
	else
		[ "$PROMPT_CHAR" ] && PROMPT_SYMBOL="%(!.# .$PROMPT_CHAR) " || PROMPT_SYMBOL='%# '
	fi
	[[ "$PROMPT_NEWLINE" && $# -eq 0 ]] && print -n '\n' # New line prompt
	if [[ "$PROMPT_EXIT" && $exitcode -eq 0 ]] || [[ -z "$PROMPT_EXIT" ]] || [ -z "$errprompt" ]; then
		print -n "%F{${PROMPT_CHARCOLOR}}$PROMPT_SYMBOL%f"
	elif [[ "$PROMPT_EXIT" && $exitcode -gt 0 ]]; then
		print -n "%F{9}$PROMPT_SYMBOL%f"
	fi
}

# User and hostname
prompt_context() {
	[ "$PROMPT_CONTEXT" = 'u' ] && prompt_section default '%n' 								# User
	[ "$PROMPT_CONTEXT" = 'm' ] && prompt_section default '%m' 								# Machine
	[[ "$PROMPT_PREFIX" && "$PROMPT_CONTEXT" = 'y' ]] && prompt_section default '%n' context && prompt_section default '%m' # User at Host
	[[ "$PROMPT_CONTEXT" = 'y' && -z "$PROMPT_PREFIX" ]] && prompt_section default '%n@%m' 					# User@Host
	[[ "$PROMPT_CONTEXT" =~ 'o' && "$USER" != "$DEFAULTUSER" ]] && prompt_section default '%n' 				# Other user
	[[ "$PROMPT_CONTEXT" =~ 'r' && "$SSH_CLIENT" ]] && prompt_section default '%n@%m'					# Remote SSH: User@Host
}

# Current directory
prompt_dir() {
	local dirargs=()
	[[ -w "${PWD}" || -z "$PROMPT_DIRLOCK" ]] && unset lockicon # Dir writable
	[[ ! -w "${PWD}" && -z "$PROMPT_DIRLOCK" ]] && PROMPT_DIRCOLOR="$PROMPT_DARKGRAY" # Dir unwriteable
	if [ "$PROMPT_DIR" = trim ]; then
		dirargs+=($PROMPT_DIRCOLOR "$(trm)${lockicon}") # trm function from fpath
	elif [ "$PROMPT_DIR" = y ]; then
		dirargs+=($PROMPT_DIRCOLOR "%~${lockicon}")
	elif [ "$PROMPT_DIR" = c ]; then
		dirargs+=($PROMPT_DIRCOLOR "%c${lockicon}")
	fi
	[[ "$PROMPT_CONTEXT" && -z "$VIRTUAL_ENV" ]] && dirargs+=(dir)
	prompt_section "${dirargs[@]}"
}

# OS icon
prompt_os() {
	local osicon
	[[ "$PROMPT_OS" && "$PROMPT_ICONS" ]] || return
	[[ "$OSTYPE" = darwin* ]] && osicon="\ue711" 			         # Apple
	[[ "$OSTYPE" = linux* ]] && osicon="\ue712" 			         # Tux
	[[ "$OSTYPE" = *bsd* || "$OSTYPE" = dragonfly* ]] && osicon="\uf30c"     # BSD
	[[ "$OSTYPE" = linux* && "$PROMPT_OS" = 'arch' ]] && osicon="\uf303"	 # Arch
	[[ "$OSTYPE" = darwin* && "$PROMPT_OS" = 'finder' ]] && osicon="\uf535"  # Mac Finder
	[[ "$OSTYPE" = darwin* && "$PROMPT_OS" = 'command' ]] && osicon="\ufb32" # Mac command
	prompt_section default "$osicon" os
}

# Clock
prompt_clock() {
	if [[ "$PROMPT_CLOCK" && -z "$RPROMPT_CLOCK" ]] || [[ "$1" = 'transient' ]]; then
		local newday=${(%):-%D{%a}}
		if [[ "$newday" != "$dayofweek" ]]; then # Day of week changed (dayofweek from prompt_precmd)
			unset newday
			prompt_section "$PROMPT_MEDGRAY" '%D{%a %X}' # %X : Time based on locale
		else
			prompt_section "$PROMPT_MEDGRAY" '%D{%X}' # %X : Time based on locale
		fi
	fi
}

# History line
prompt_hist() {
	if [[ "$PROMPT_HISTLINE" && -z "$RPROMPT_HISTLINE" ]] || [[ "$1" = 'transient' ]]; then
		[ "$incognito" ] && return
		prompt_section "$PROMPT_MEDGRAY2" "%h"
	fi
}

# Python virtual environment status
prompt_venv() {
	[ "$PROMPT_VENV" ] || return
	if [ "$VIRTUAL_ENV" ]; then
		local venvargs=()
		[ -z "$PROMPT_DIRCOLOR" ] && local PROMPT_DIRCOLOR="$PROMPT_STEELBLUE"
		venvargs+=($PROMPT_DIRCOLOR "(${VIRTUAL_ENV##*/})")
		[ "$PROMPT_CONTEXT" ] && venvargs+=(dir)
		prompt_section "${venvargs[@]}"
	fi
}

# Docker machine context
prompt_dockercontext() {
	local docker_remote_context
	if [ $DOCKER_MACHINE_NAME ]; then
		docker_remote_context="$DOCKER_MACHINE_NAME"
	elif [ $DOCKER_HOST ]; then
		# Remove protocol (tcp://) and port number from displayed Docker host
		local parstring=${DOCKER_HOST#*//}
		docker_remote_context=${parstring%:*}
	fi
	[ -z $docker_remote_context ] && return
	print -n "${docker_remote_context}"
}

# Docker
prompt_docker() {
	(($+commands[docker])) || return
	[[ "$PROMPT_DOCKER" || "$RPROMPT_DOCKER" ]] || return
	[[ -n "$RPROMPT_DOCKER" && ${funcstack[2]} = "prompt_build" ]] && return # Respect module position choice
	[[ -z "$RPROMPT_DOCKER" && ${funcstack[2]} = "prompt_rbuild" ]] && return
	# Better support for docker environment vars: https://docs.docker.com/compose/reference/envvars/
	local compose_exists=false
	if [ "$COMPOSE_FILE" ]; then
		# Use COMPOSE_PATH_SEPARATOR or colon as default
		local separator=${COMPOSE_PATH_SEPARATOR:-":"}
		# COMPOSE_FILE may have several filenames separated by colon, test all of them
		local filenames=("${(@ps/$separator/)COMPOSE_FILE}")
		for filename in $filenames; do
			if [[ ! -f $filename ]]; then
				compose_exists=false
				break
			fi
			compose_exists=true
		done
		# Must return if COMPOSE_FILE is present but invalid
		[ "$compose_exists" = false ] && return
	fi
	local docker_context="$(prompt_dockercontext)" PROMPT_SECTIONFN
	# Show Docker status only for Docker-specific folders or when connected to external host
	[[ "$compose_exists" == true || -f Dockerfile || -f docker-compose.yml || -f /.dockerenv || $docker_context ]] || return
	[ "$RPROMPT_DOCKER" ] && PROMPT_SECTIONFN="prompt_rsection" || PROMPT_SECTIONFN="prompt_section" # Set prompt section
	$PROMPT_SECTIONFN $PROMPT_LIGHTBLUE "${dockericon}[${docker_context}]" docker
}

# VCS module status
prompt_vcs() {
	(( $+commands[git] )) || return
	[[ "$PROMPT_GITVCS" || "$RPROMPT_GITVCS" ]] || return
	[ $UID -eq 0 ] && return # No git prompt for root user
	[[ -n "$RPROMPT_GITVCS" && ${funcstack[2]} = "prompt_build" ]] && return # Respect module prompt choice
	[[ -z "$RPROMPT_GITVCS" && ${funcstack[2]} = "prompt_rbuild" ]] && return
	local PROMPT_SECTIONFN
	[ "$RPROMPT_GITVCS" ] && PROMPT_SECTIONFN="prompt_rsection" || PROMPT_SECTIONFN="prompt_section" # Set prompt section
	[ "${vcs_info_msg_0_}" ] && $PROMPT_SECTIONFN default "${vcs_info_msg_0_}" git
}

# Status for clock, cmd time, history line, job status, exit code.
prompt_status() {
	local symbols=()
	# Exit code
	if [ "$RPROMPT_EXITCODE" ] && [ "$exitcode" -gt 0 ]; then
		[ "$RPROMPT_EXITSIG" ] && prompt_exitsig
		symbols+=("%F{$PROMPT_RED}${exiticon}${exitcode}%f")
	fi
	# Cmd time
	if [[ "$RPROMPT_CMDTIME" && -z "$nocmdtime" ]]; then # nocmdtime set in prompt_accept-line
		prompt_humantime $timer_result # timer_result set in prompt_precmd
		[ "$PROMPT_PREFIX" ] && local prefix="took " || local prefix=$clockicon
		[[ "$timer_result" -ge 5 && "$timer_result" -lt 15 ]] && symbols+=("%F{$PROMPT_MEDGRAY}${prefix}$humant")
		[[ "$timer_result" -ge 15 && "$timer_result" -lt 30 ]] && symbols+=("%F{$PROMPT_MEDGRAY}${prefix}%F{$PROMPT_ORANGE}$humant") # Orange time
		[[ "$timer_result" -ge 30 ]] && symbols+=("%F{$PROMPT_MEDGRAY}${prefix}%F{$PROMPT_RED}$humant") # Red time
	fi
	# History line
	[[ "$RPROMPT_HISTLINE" && $BUFFER && -z "$incognito" ]] && symbols+=("%F{$PROMPT_MEDGRAY2}%h%f")
	# Clock
	if [[ "$RPROMPT_CLOCK" ]]; then
		local rnewday=${(%):-%D{%a}}
		if [[ "$rnewday" != "$dayofweek" ]]; then # Day of week changed
		local RPROMPT_CLOCKDAY="$rnewday"
			unset rnewday
			symbols+=("%F{$PROMPT_MEDGRAY}$RPROMPT_CLOCKDAY %D{%X}%f")
		else
			symbols+=("%F{$PROMPT_MEDGRAY}%D{%X}%f")
		fi
	fi
	# Jobs
	if [ "$RPROMPT_JOBS" ]; then
		if [ "$PROMPT_ICONS" ]; then
			[ "$jobnum" -eq 1 ] && symbols+=("%F{$PROMPT_LIGHTGRAY}${jobicon}%f")  # 1 job
			[ "$jobnum" -gt 1 ] && symbols+=("%F{$PROMPT_LIGHTGRAY}${jobsicon}%f") # >1 job
		else
			[ "$jobnum" -gt 0 ] && symbols+=("%F{$PROMPT_LIGHTGRAY}${jobnum}%f")
		fi
	fi
	[ "${symbols[*]}" ] && prompt_rsection default "${symbols[*]}" || :
}

# Convert time to a human readable format
# Adapted from https://github.com/sindresorhus/pretty-time-zsh
prompt_humantime() {
	typeset -g humant
	local human total_seconds=$1
	local days=$(( total_seconds / 60 / 60 / 24 ))
	local hours=$(( total_seconds / 60 / 60 % 24 ))
	local minutes=$(( total_seconds / 60 % 60 ))
	local seconds=$(( total_seconds % 60 ))
	(( days > 0 )) && human+="${days}d "
	(( hours > 0 )) && human+="${hours}h "
	(( minutes > 0 )) && human+="${minutes}m "
	human+="${seconds}s"
	humant=$human
}

# Return exit code names. If no match, then use exit code number.
prompt_exitsig() {
	case $exitcode in
		-1)  exitcode="FATAL(-1)"	   	;;
		1)   exitcode="WARN(1)"		   	;;
		2)   exitcode="BUILTINMISUSE(2)"   	;;
		19)  exitcode="STOP(19)"	   	;;
		20)  exitcode="TSTP(20)"	   	;;
		21)  exitcode="TTIN(21)"	   	;;
		22)  exitcode="TTOU(22)"	   	;;
		126) exitcode="CCANNOTINVOKE(126)" 	;;
		127) exitcode="CNOTFOUND(127)"	   	;;
		129) exitcode="HUP(129)"	   	;;
		130) exitcode="INT(130)"	   	;;
		131) exitcode="QUIT(131)"	   	;;
		132) exitcode="ILL(132)"	   	;;
		134) exitcode="ABRT(134)"	   	;;
		136) exitcode="FPE(136)"	   	;;
		137) exitcode="KILL(137)"	   	;;
		139) exitcode="SEGV(139)"	   	;;
		141) exitcode="PIPE(141)"	   	;;
		143) exitcode="TERM(143)"	   	;;
	esac
}

# Reset prompt error color
prompt_exitreset() {
	unset errprompt
	read -r exitreset <&$1 # Read fd
	# Reset prompt unless a condition is met
	[[ $WIDGET == *(complete|delete|list|search|statusline)* ]] || [[ "$_lastcomp[insert]" =~ "^automenu$|^menu:" \
		|| $statusline || "$paste" || "$__searching" || "$dm" ]] \
			|| { zle && builtin zle reset-prompt }
	exec {1}<&- # Close fd
	zle -F $1 # Close handler
}

# Custom accept-line function to assist with prompt tasks
prompt_acceptline() {
	# Handle prompt vars
	[ "$paste" ] 	    && unset paste
	[ "$timer_result" ] && unset timer_result
	[ "$__searching" ]  && unset __searching
	[ "$errprompt" ]    && unset errprompt
	[ "$nocmdtime" ]    && unset nocmdtime
	[ "$dm" ] 	    && unset dm
	# Show histline or executed time on previous buffer
	[[ "$RPROMPT_HISTLINE" || "$PROMPT_CLOCKEXE" && -z "$PROMPT_TRANSIENT" ]] && zle .reset-prompt
	# Blacklist commands from CMDTIME
	local prog="(hist|[ht,t]op|fe|fd|fh|fkill|suroot|oa|dm)"
	local head="(micro|m |nano|vi|vim|man|ssh|tmux|wtch)*"
	local tail="*(fzf|less|more)"
	[[ $BUFFER =~ ${prog} || $BUFFER = ${~head} || $BUFFER = ${~tail} ]] && typeset -g nocmdtime='y'
	# Run builtin accept-line
	zle .accept-line
}

# Transient prompt
# Adapted from https://www.zsh.org/mla/users/2019/msg00633.html
prompt_transient() {
	if [ "$PROMPT_TRANSIENT" ]; then
		emulate -L zsh
		[[ $CONTEXT == start ]] || return 0
		while true; do
			# Start regular line editor
			(( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1] # Re-enable bracketed paste
			zle .recursive-edit
			local -i ret=$?
			# If we received EOT exit the shell
			[[ $ret == 0 && $KEYS == $'\4' ]] || break
			[[ -o ignore_eof ]] || exit 0
		done
		local TPS1
		local oldPS1=$PS1
		# Sections for transient prompt
		if [ $BUFFER ]; then # Show only on prompts with executed buffers
			[[ "$PROMPT_TRANSIENTOPT" =~ 'clock' ]] && TPS1+='$(prompt_clock transient)'
			[[ "$PROMPT_TRANSIENTOPT" =~ 'hist' ]]  && TPS1+='$(prompt_hist transient)'
		fi
		TPS1+='$(prompt_end)'
		PS1="$TPS1"
		# Line editor is finished - shorten the prompt
		zle .reset-prompt
		PS1="${tnewline}$oldPS1"
		[ "$tnewline" ] && unset tnewline
		if (( ret )); then # Ctrl-C
			zle .send-break
		else # Enter
			zle .accept-line
		fi
		return ret
	fi
}

# Prompt schedule to tick clock
# Adapted from https://www.zsh.org/mla/users/2007/msg00946.html
prompt_sched() {
	local sched_exitcode=$?
	local -i i=${"${(@)zsh_scheduled_events#*:*:}"[(I)schedprompt]}
	emulate -L zsh
	((i)) && sched -$i
	# Reset prompt unless a condition is met - Adapted from https://stackoverflow.com/a/42982148
	[[ $WIDGET == *(complete|delete|list|search|statusline)* ]] || [[ "$_lastcomp[insert]" =~ "^automenu$|^menu:" \
		|| $statusline || "$paste" || "$__searching" || "$dm" ]] \
			|| { zle && builtin zle reset-prompt }
	sched +1 prompt_sched # 1s schedule
	return $sched_exitcode # Restore prompt exit code
}

# Evaluate command
prompt_preexec() {
	typeset -ghi nextcmd lastcmd
	((nextcmd++)) # Next command initiated
	[ "$RPROMPT_CMDTIME" ] && typeset -g timer_sec=${timer_sec:-$EPOCHSECONDS} # Start command timer
}

# Execute before next prompt
prompt_precmd() {
	typeset -g exitcode=$? 	      # Store cmd exit code
	typeset -g jobnum=$#jobstates # Store number of jobs
	[ "$exitcode" -gt 0 ] && errprompt='on'
	[[ "$PROMPT_CLOCK" || "$RPROMPT_CLOCK" || "$PROMPT_TRANSIENTOPT" =~ "clock" ]] && \
		typeset -g dayofweek=${(%):-%D{%a}} # Store day of week
	((nextcmd==lastcmd)) && unset exitcode nextcmd lastcmd || ((lastcmd=nextcmd)) # Unset exitcode on next buffer
	# Command time
	if [[ "$RPROMPT_CMDTIME" && $timer_sec ]]; then
		local timer_diff
		((timer_diff=EPOCHREALTIME-timer_sec))
		typeset -g timer_result=${timer_diff%.*} # Remove decimals
		unset timer_sec
	fi
	# Start async timer for error prompt color reset
	if [[ "$PROMPT_EXIT" && "$PROMPT_EXITRESET" ]]; then
		if [ "$errprompt" = 'on' ]; then
			exec {FD1}< <(zselect -t 500) # Initialize file descriptor and fork timer - 5s
			zle -F $FD1 prompt_exitreset # Handle input from fd
		fi
	fi
	# Tab and window title
	# 1: tab 2: window
	if [ "$PROMPT_TITLES" ]; then
		local context
		[ "$PROMPT_CONTEXT" = 'u' ] && context='%n: '
		[ "$PROMPT_CONTEXT" = 'm' ] && context='%m: '
		[ "$PROMPT_CONTEXT" = 'y' ] && context='%n@%m: '
		[[ "$PROMPT_CONTEXT" == 'o' && "$USER" != "$DEFAULTUSER" ]] && context='%n: '
		[[ "$PROMPT_CONTEXT" == 'r' && "$SSH_CLIENT" ]] && context='%n%m: '
		[ "$UID" = 0 ] && print -Pn "\e]1;# ${context}%c\a" || print -Pn "\e]1;${context}%c\a"
		print -Pn "\e]2;${context}%c ${ZSH_ARGZERO}\a"
	fi
}

# Build prompt
prompt_build() {
	prompt_clock
	prompt_hist
	prompt_context
	prompt_os
	prompt_venv
	prompt_dir
	prompt_docker
	prompt_vcs
	prompt_end
}

# Build rprompt
prompt_rbuild() {
	[ "$RPROMPT_OFF" ] && return || :
	prompt_docker
	prompt_vcs
	prompt_status
}

# Setup the things
prompt_setup() {
	# Defines and hooks
	autoload -Uz add-zsh-hook colors && colors
	add-zsh-hook preexec prompt_preexec
	add-zsh-hook precmd prompt_precmd
	zle -N accept-line prompt_acceptline
	zle-line-init()	{ key_start ; prompt_transient }
	zle-line-finish() key_end
	zle -N zle-line-init
	zle -N zle-line-finish
	# Prompt colors
	typeset -g PROMPT_RED=160
	typeset -g PROMPT_ORANGE=166
	typeset -g PROMPT_LIGHTBLUE=39
	typeset -g PROMPT_STEELBLUE=75
	typeset -g PROMPT_LIGHTGRAY=252
	typeset -g PROMPT_MEDGRAY=249
	typeset -g PROMPT_MEDGRAY2=246
	typeset -g PROMPT_DARKGRAY=244
	# Glyphs
	if [[ "$PROMPT_ICONS" && -z "$SSH_CLIENT" ]]; then
		typeset -g lockicon=" \uf023"	# padlock
		typeset -g clockicon="\uf017 "	# clock
		typeset -g exiticon="\u21aa"	# arrow
		typeset -g jobicon="\uf013"	# cog
		typeset -g jobsicon="\uf085"	# cogs
		typeset -g dockericon="\uf308 "	# whale
		typeset -g ghosticon="\uf79f "	# ghost
	fi
	# Settings and utilities
	ZLE_RPROMPT_INDENT=0 # Set right prompt margin to 0
	[ "$PROMPT_BOTTOM" ] && tput cup $LINES # Pin prompt to bottom of terminal
	[ "$PROMPT_VENV" ] && chpwd_functions+=(avenv) # Add python auto venv to chpwd
	[ "$PROMPT_EXITRESET" ] && zmodload zsh/zselect # Load timer module
	[[ "$PROMPT_CLOCK" || "$RPROMPT_CMDTIME" || "$PROMPT_MOTD" ]] && zmodload zsh/datetime # Load time module
	[[ "$PROMPT_ICONS" && $SSH_TTY ]] && unset PROMPT_ICONS # No glyph icons in an SSH session
	[ -z "$PROMPT_DIRCOLOR" ] && typeset -g PROMPT_DIRCOLOR="$PROMPT_STEELBLUE" # Default dir color
	if [[ "$PROMPT_TRANSIENT" && "$PROMPT_TRANSIENTOPT" =~ 'newline' ]]; then # New line after transient prompt
		typeset -g tnewline=$'\n'
	fi
	if [ "$PROMPT_CLOCKTICK" ] && [[ "$PROMPT_CLOCK" || "$RPROMPT_CLOCK" ]]; then # Schedule tick clock function
		prompt_sched
	fi
	# Refresh background job number
	TRAPCHLD() {
		if [ "$RPROMPT_JOBS" ]; then
			jobnum=$#jobstates
			zle && builtin zle reset-prompt
		fi
	}
	PROMPT='$(prompt_build)'
	RPROMPT='$(prompt_rbuild)'
}

prompt_setup "$@"
