# Prompt theme
# Adapted from spaceship-prompt https://github.com/denysdovhan/spaceship-prompt and agnoster https://github.com/agnoster/agnoster-zsh-theme

# Begin a section
# If foreground argument is omitted, renders default foreground.
prompt_section() {
	local fg
	local prefixcol="white"
	[ -n $1 ] && fg="%F{$1}" || fg="%f"
	if [[ -n $3 && -n "$PROMPT_PREFIX" ]]; then
		[ $3 = "dir" ] && print -n "%F{$prefixcol}in %f"
		[ $3 = "docker" ] && print -n "%F{$prefixcol}on %f"
		[ $3 = "git" ] && print -n "%F{$prefixcol}on %f"
	fi
	[ -n "$PROMPT_BOLD" ] && print -n "%B"
	print -n "%{$fg%}"
	[ -n $2 ] && print -n "$2 "
	[[ -n "$PROMPT_PREFIX" && $3 == "context" ]] && print -n "%F{$prefixcol}at %f"
	[ -n "$PROMPT_BOLD" ] && print -n "%b"
}

# Begin an rprompt section
prompt_rsection() {
	local fg
	local prefixcol="245"
	[ -n $1 ] && fg="%F{$1}" || fg="%f"
	if [[ -n $3 && -n "$PROMPT_PREFIX" ]]; then
		[ $3 = "docker" ] && print -n "%F{$prefixcol} on%f"
		[ $3 = "git" ] && print -n "%F{$prefixcol} on%f"
	fi
	[ -n "$PROMPT_BOLD" ] && print -n "%B"
	print -n "%{$fg%}"
	[ -n $2 ] && print -n " $2"
	[ -n "$PROMPT_BOLD" ] && print -n "%b"
}

# End the prompt closing open sections and set the prompt
prompt_end() {
	if [[ -n "$PROMPT_EXIT" && $exitcode -eq 0 ]] || [[ -z "$PROMPT_EXIT" ]] || [ $errchar = "off" ]; then
		[ -z "$PROMPT_CHARCOL" ] && local PROMPT_CHARCOL=default
		[ -n "$PROMPT_CHAR" ] && print -n "%{%F{"$PROMPT_CHARCOL"}%}$PROMPT_CHAR %f" || \
			print -n "%F{"$PROMPT_CHARCOL"}%# %f"
	elif [[ -n "$PROMPT_EXIT" && $exitcode -gt 0 ]]; then
		[ -n "$PROMPT_CHAR" ] && print -n "%{%F{9}%}$PROMPT_CHAR %f" || print -n "%F{9}%# %f"
	fi
}

# User and hostname
prompt_context() {
	[ "$PROMPT_CONTEXT" = "u" ] && prompt_section default "%n" # User
	[[ -n "$PROMPT_PREFIX" && "$PROMPT_CONTEXT" = "y" ]] && prompt_section default "%n" context && prompt_section default "%m" # User & Host
	[[ -z "$PROMPT_PREFIX" && "$PROMPT_CONTEXT" = "y" ]] && prompt_section default "%n@%m" # User@Host
	[[ "$USER" != "$DEFAULTUSER" && "$PROMPT_CONTEXT" == "o" ]] && prompt_section default "%n" # Other user
}

# Current directory
prompt_dir() {
	# Trimmed path from trm function in fpath
	local dirargs=()
	[ -z "$PROMPT_DIRCOLOR" ] && local PROMPT_DIRCOLOR=cyan
	if [[ ! -w "${PWD}" && -n "$PROMPT_DIRLOCK" ]]; then # Directory not writable
		if [ -n "$PROMPT_DIRTRIM" ]; then
			dirargs+=($PROMPT_DIRCOLOR "$(trm)${lockicon}")
		else
			dirargs+=($PROMPT_DIRCOLOR "%~${lockicon}")
		fi
	else
		if [ -n "$PROMPT_DIRTRIM" ]; then
			dirargs+=($PROMPT_DIRCOLOR $(trm))
		else
			dirargs+=($PROMPT_DIRCOLOR %~)
		fi
	fi
	[[ -n "$PROMPT_CONTEXT" && -z "$VIRTUAL_ENV" ]] && dirargs+=(dir)
	prompt_section "${dirargs[@]}"
	unset PROMPT_DIRCOLOR
}

# Clock
prompt_clock() {
	if [[ -n "$PROMPT_CLOCK" && -z "$RPROMPT_CLOCK" ]]; then
		[ "$PROMPT_CLOCK" = "y" ]  && prompt_section 249 '%D{%H:%M:%S}'
		[ "$PROMPT_CLOCK" = "12" ] && prompt_section 249 '%D{%I:%M:%S}'
	fi
}

# History line
prompt_hist() {
	[[ -n "$PROMPT_HISTLINE" && -z "$RPROMPT_HISTLINE" && -n "$histline" ]] && prompt_section 245 "%h"
}

# Python virtual environment name
prompt_venv() {
	if [ -n "$PROMPT_VENV" ]; then
		[ -z "$PROMPT_DIRCOLOR" ] && local PROMPT_DIRCOLOR=cyan
		if [ -n "$VIRTUAL_ENV" ]; then
			local venvargs=()
			venvargs+=($PROMPT_DIRCOLOR "[${VIRTUAL_ENV##*/}]")
			[ -n "$PROMPT_CONTEXT" ] && venvargs+=(dir)
			prompt_section "${venvargs[@]}"
		fi
	fi
}

# Docker machine context
prompt_dockercontext() {
	local docker_remote_context
	if [ -n $DOCKER_MACHINE_NAME ]; then
		docker_remote_context="$DOCKER_MACHINE_NAME"
	elif [ -n $DOCKER_HOST ]; then
		# Remove protocol (tcp://) and port number from displayed Docker host
		local parstring=${DOCKER_HOST#*//}
		docker_remote_context=${parstring%:*}
	else
		# Current docker context, ignoring the local "default" context.
		docker_remote_context=$(docker context ls --format '{{if .Current}}{{if ne .Name "default"}}{{.Name}}{{end}}{{end}}' 2>/dev/null | tr -d '\n')
	fi
	[ -z $docker_remote_context ] && return
	print -n "${docker_remote_context}"
}

# Docker
prompt_docker() {
	[ -n "$PROMPT_DOCKER" ] || return
	# Better support for docker environment vars: https://docs.docker.com/compose/reference/envvars/
	local compose_exists=false
	if [ -n "$COMPOSE_FILE" ]; then
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
	local docker_context="$(prompt_dockercontext)"
	# Show Docker status only for Docker-specific folders or when connected to external host
	[[ "$compose_exists" == true || -f Dockerfile || -f docker-compose.yml || -f /.dockerenv || -n $docker_context ]] || return
	$PROMPT_SECTIONCMD cyan "${dockericon}[${docker_context}]" docker
}

# Git status with git-prompt async plugin
prompt_git() {
	(($+commands[git])) || return # Git not installed
	[ $UID -eq 0 ] && return # No git prompt for root user
	[[ -n "$PROMPT_GIT" && "$GITREPO" == "true" ]] && $PROMPT_SECTIONCMD default "$(gitprompt)" git
}

# Status for clock, cmd time, history line, job status, exit code.
prompt_status() {
   local symbols=()
	if [ -n "$RPROMPT_EXITCODE" ] && [ "$exitcode" -gt 0 ]; then # Exit code
		[ -n "$RPROMPT_EXITSIG" ] && prompt_exitsig
		prompt_rsection 160 "${exiticon}${exitcode}"
	fi
	[[ -n "$RPROMPT_HISTLINE" && -n $BUFFER && -n "$histline" ]] && prompt_rsection 245 "%h" # History line
	if [[ -n "$RPROMPT_CMDTIME" && -z "$nocmdtime" ]]; then # Command time (nocmdtime from prompt_accept-line)
		prompt_humantime $timer_result
		[ -n "$PROMPT_PREFIX" ] && local prefix="took " || local prefix=$clockicon
		[[ "$timer_result" -ge 5 && "$timer_result" -lt 10 ]] && symbols+=("%F{249}${prefix}$humant")
		[[ "$timer_result" -ge 15 && "$timer_result" -lt 30 ]] && symbols+=("%F{249}${prefix}%F{166}$humant") # Orange time
		[[ "$timer_result" -ge 30 ]] && symbols+=("%F{249}${prefix}%F{160}$humant") # Red time
	fi
	[ "$RPROMPT_CLOCK" = "y" ] && symbols+=("%F{249}%D{%H:%M:%S}") # 24H clock
	[ "$RPROMPT_CLOCK" = 12 ] && symbols+=("%F{249}%D{%I:%M:%S}")  # 12H clock
	[[ -n "$PROMPT_ICONS" && "$jobnum" -eq 1 ]] && symbols+=("%F{252}${jobicon}%f")
	[[ -n "$PROMPT_ICONS" && "$jobnum" -gt 1 ]] && symbols+=("%F{252}${jobsicon}%f") # >1 job
	[ -n "${symbols[*]}" ] && prompt_rsection 235 "${symbols[*]}"
}

# Convert time to a human readable format - Adapted from https://github.com/sindresorhus/pretty-time-zsh
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
			-1)  exitcode="FATAL(-1)" ;;
			1)   exitcode="WARN(1)" ;;
			2)   exitcode="BUILTINMISUSE(2)" ;;
			19)  exitcode="STOP(19)" ;;
			20)  exitcode="TSTP(20)" ;;
			21)  exitcode="TTIN(21)" ;;
			22)  exitcode="TTOU(22)" ;;
			126) exitcode="CCANNOTINVOKE(126)" ;;
			127) exitcode="CNOTFOUND(127)" ;;
			129) exitcode="HUP(129)" ;;
			130) exitcode="INT(130)" ;;
			131) exitcode="QUIT(131)" ;;
			132) exitcode="ILL(132)" ;;
			134) exitcode="ABRT(134)" ;;
			136) exitcode="FPE(136)" ;;
			137) exitcode="KILL(137)" ;;
			139) exitcode="SEGV(139)" ;;
			141) exitcode="PIPE(141)" ;;
			143) exitcode="TERM(143)" ;;
	esac
}

# Reset prompt error color
prompt_exitreset() {
	typeset -g errchar=off
	read -r exitreset <&$1 # Read fd
	zle && builtin zle reset-prompt # Reset prompt
	zle -F $1 # Call handler
	exec {1}<&- # Close fd
}

# Evaluate command
prompt_preexec() {
	typeset -ghi nextcmd lastcmd
	((nextcmd++)) # Next command initiated
	[ -n "$RPROMPT_CMDTIME" ] && typeset -g timer_sec=${timer_sec:-$EPOCHSECONDS} # Start command timer
	[ -n $BUFFER ] && typeset -g histline=y # Zle buffer set - Enable histline
}

# Execute before next prompt
prompt_precmd() {
	typeset -g exitcode=$? # Store prompt exit code
	typeset -g jobnum=$#jobstates # Store job number
	((nextcmd==lastcmd)) && unset exitcode nextcmd lastcmd || ((lastcmd=nextcmd)) # Unset exitcode on next buffer
	# Start async timer for error prompt color reset
	if [ -n "$PROMPT_EXIT" ]; then
		if [ "$exitcode" -gt 0 ]; then
			typeset -g errchar=on
			! type zselect > /dev/null && zmodload zsh/zselect # Load timer module
			exec {FD1}< <(zselect -t 300) # Initialize file descriptor and fork timer - 3s
			zle -F $FD1 prompt_exitreset # Handle input from fd
		fi
	fi
	# Command time
	if [[ -n "$RPROMPT_CMDTIME" && -n $timer_sec ]]; then
		local timer_diff
		((timer_diff=EPOCHREALTIME-timer_sec))
		typeset -g timer_result
		read -r timer_result < <(printf '%.*f\n' 0 ${timer_diff}) # 0 decimal
		unset timer_sec
	fi
	# Tab and window title
	if [ -n "$PROMPT_TITLES" ]; then
		if [ "$PROMPT_CONTEXT" = "u" ]; then
			print -Pn "\e]1;%n %c\a"
			print -Pn "\e]2;%n %c $0\a"
		elif [ "$PROMPT_CONTEXT" = "uh" ]; then
			print -Pn "\e]1;%n@%m: %c\a"
			print -Pn "\e]2;%n@%m: %c $0\a"
		elif [[ "$PROMPT_CONTEXT" == "o" && "$USER" != "$DEFAULTUSER" ]]; then
			print -Pn "\e]1;%n: %c\a"
			print -Pn "\e]2;%n: %c $0\a"
		else
			[ "$UID" = 0 ] && print -Pn "\e]1;# %c\a" || print -Pn "\e]1;%c\a"
			[ "$UID" = 0 ] && print -Pn "\e]2;# %c -${0##*/}\a" || print -Pn "\e]2;%c $0\a"
		fi
	fi
}

# Execute at shell exit
prompt_exit() {
	[[ -n "$PROMPT_RJOB" && -n "$jpid" ]] && kill $jpid # Kill disowned job from fpath
}

# Build prompt
prompt_build() {
	[ "$1" != "noclock" ] && prompt_clock
	prompt_context
	prompt_venv
	prompt_dir
	[ -z "$RPROMPT_MODULES" ] && prompt_docker
	[ -z "$RPROMPT_MODULES" ] && prompt_git
	prompt_end
}

# Build rprompt
prompt_rbuild() {
	[ -n "$RPROMPT_OFF" ] && return
	[ -n "$RPROMPT_MODULES" ] && prompt_docker
	[ -n "$RPROMPT_MODULES" ] && prompt_git
	prompt_status
}

# Setup the things
prompt_setup() {
	autoload -Uz add-zsh-hook colors && colors
	add-zsh-hook preexec prompt_preexec
	add-zsh-hook precmd prompt_precmd
	add-zsh-hook zshexit prompt_exit
	[ -n "$RPROMPT_CMDTIME" ] && ! type strftime > /dev/null && zmodload zsh/datetime # Load time module for cmdtime
	ZLE_RPROMPT_INDENT=0 # Set right prompt margin to 0
	# Set module prompt section command
	typeset -g PROMPT_SECTIONCMD
	[ -n "$RPROMPT_MODULES" ] && PROMPT_SECTIONCMD="prompt_rsection" || PROMPT_SECTIONCMD="prompt_section"
	# Glyphs
	[[ -n $SSH_TTY ]] && unset PROMPT_ICONS # No glyph icons in an SSH session
	if [ -n "$PROMPT_ICONS" ]; then
		typeset -g lockicon=" \uf023"		# Padlock
		typeset -g dockericon="\uf308 "	# Whale
		typeset -g exiticon="\u21aa"		# Return
		typeset -g clockicon="\uf017 "	# Clock
		typeset -g jobicon="\uf013"		# Cog
		typeset -g jobsicon="\uf085"		# Cogs
		typeset -g giticons=y				# Enable gitprompt icons
	fi
	# Custom accept-line widget to assist with prompt tasks
	prompt_accept-line() {
		# Handle prompt vars
		[ -n "$paste" ] 			&& unset paste
		[ -n "$timer_result" ]	&& unset timer_result
		[ -n "$__searching" ] 	&& unset __searching
		[ -n "$dirmsg" ] 			&& unset dirmsg
		[ -n "$dm" ] 				&& unset dm
		[[ -z $BUFFER && -n $histline ]] && unset histline
		[[ -n $BUFFER && -z $histline ]]	&& typeset -g histline=y
		# Transient prompt
		if [ -n "$PROMPT_TRANSIENT" ]; then
			local oldPS1="$PS1"
			local TPS1
			[[ $PROMPT_TRANSIENTOPT =~ "clock" ]]    && TPS1+='$(prompt_clock)'
			[[ $PROMPT_TRANSIENTOPT =~ "histline" ]] && TPS1+='$(prompt_hist)'
			local errchar=off
			TPS1+='$(prompt_end)'
			PS1=$TPS1
			builtin zle reset-prompt
			unset TPS1
			PS1="$oldPS1"
		# Hist line on previous executed prompt
		elif [[ -n $BUFFER ]]; then
			local oldPS1="$PS1"
			PS1='$(prompt_clock)$(prompt_hist)$(prompt_build noclock)'
			builtin zle reset-prompt
			PS1="$oldPS1"
		fi
		# Blacklist commands from CMDTIME
		local prog="(sudo -s|suroot|hist|htop|fe|fcd|fkill|oa)"
		local head="(micro|m |nano|vi|vim|man|ssh|tmux|top|fcd|wtch)*"
		local tail="*(fzy|less)"
		if [[ $BUFFER =~ ${prog} || $BUFFER == ${~head} || $BUFFER == ${~tail} ]]; then
			typeset -g nocmdtime=y
		else
			[ -n "$nocmdtime" ] && unset nocmdtime
		fi
		[ -n "$PROMPT_EXPALIAS" ] && zle _expand_alias # Expand aliases
		zle .accept-line # Run builtin accept-line
	}
	zle -N accept-line prompt_accept-line
	# Refresh prompt each second to tick clock
	# Adapted from https://www.zsh.org/mla/users/2007/msg00946.html
	if [ -n "$PROMPT_CLOCKTICK" ] && [[ -n "$PROMPT_CLOCK" || -n "$RPROMPT_CLOCK" ]]; then
		schedprompt() {
			local saved_exitcode=$?
			local -i i=${"${(@)zsh_scheduled_events#*:*:}"[(I)schedprompt]}
			emulate -L zsh
			((i)) && sched -$i
			# Reset prompt unless a condition is met
			[[ $WIDGET == *(complete|delete|list|search|statusline)* || $ZLE_STATE == *(history|insert|overwrite)* \
				|| -n $statusline || -n "$paste" || -n "$__searching" || -n "$dm" || -n "$dirmsg" ]] || { zle && builtin zle reset-prompt }
			sched +1 schedprompt # 1s schedule
			return $saved_exitcode # Retore prompt exit code
		}
		schedprompt
	fi
	# Ctrl-C
	if [[ -n "$RPROMPT_EXITCODE" || -n "$RPROMPT_CLOCKTICK" ]]; then
		TRAPINT() {
			[ -n "$paste" ]       && unset paste
			[ -n "$exitcode" ]    && unset exitcode
			[ -n "$__searching" ] && unset __searching
			return $((128+$1))
		}
	fi
	# Prompt
	PROMPT='$(prompt_build)'
	RPROMPT='$(prompt_rbuild)'
}

prompt_setup "$@"
