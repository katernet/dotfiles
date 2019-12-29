# Adapted from agnoster ZSH theme - https://github.com/agnoster/agnoster-zsh-theme

# Begin a segment
# Takes two arguments, background and foreground. If omitted, renders default background/foreground.
prompt_segment() {
	[ -n "$SSH_CLIENT" ] && typeset -g SEGMENT_SEPARATOR='\u27e9' || typeset -g SEGMENT_SEPARATOR='\ue0b0'
	local bg fg
	[ -n $1 ] && bg="%K{$1}" || bg="%k"
	[ -n $2 ] && fg="%F{$2}" || fg="%f"
	if [[ -n $CURRENT_BG && $1 != "$CURRENT_BG" ]]; then
		[ -n "$SSH_CLIENT" ] && print -n " %{$bg%F{$1}%}$SEGMENT_SEPARATOR%{$fg%} " || print -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
	else
		[[ "$USER" = "$DEFAULTUSER" && -z "$SSH_CLIENT" ]] && print -n "%{$bg%}%{$fg%} " || print -n "%{$bg%}%{$fg%}"
	fi
	typeset -g CURRENT_BG=$1
	[ -n $3 ] && echo -n "$3"
}

# Begin an rprompt segment
prompt_rsegment() {
	[ -n "$SSH_CLIENT" ] && typeset -g RSEGMENT_SEPARATOR='\u27e8' || typeset -g RSEGMENT_SEPARATOR='\ue0b2'
	local bg fg
	[ -n $1 ] && bg="%K{$1}" || bg="%k"
	[ -n $2 ] && fg="%F{$2}" || fg="%f"
	if [[ -n $CURRENT_BG && $1 != "$CURRENT_BG" ]]; then
		print -n "%{%K{$CURRENT_BG}%F{$1}%}$RSEGMENT_SEPARATOR%{$bg%}%{$fg%} "
	else
		print -n "%F{$1}%{%K{default}%}$RSEGMENT_SEPARATOR%{$bg%}%{$fg%} "
	fi
	typeset -g CURRENT_BG=$1
	[ -n $3 ] && echo -n "$3"
	print -n "%E" # Draw segment over space at rprompt EOL
}

# End the prompt closing any open segments and set the prompt
prompt_end() {
	[ -n $CURRENT_BG ] && print -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR" || print -n "%{%k%}"
	if [[ -n "$RPROMPT_RETURN" || $retcode -eq 0 ]]; then
		print -n "%{%f%} %# "
	else
		print -n "%F{9} %# %f"
	fi
	unset CURRENT_BG
}

# End rprompt closing any open segments
prompt_rend() {
	[ -n $CURRENT_BG ] && print -n "%{%k%}"
	unset CURRENT_BG
}

# User and hostname
prompt_context() {
	[ -n "$SSH_CLIENT" ] && prompt_segment black default "%n@%m" && return # SSH - User and hostname
	[ "$USER" != "$DEFAULTUSER" ] && prompt_segment black default "%n" # Other user - Show user
}

# Current directory
prompt_dir() {
	# Truncated paths from shrinkpath function in fpath
	[ -n "$SSH_CLIENT" ] && prompt_segment default cyan $(_shrinkpath) && return
	if [ ! -w "${PWD}" ]; then # Directory not writable
		prompt_segment cyan black "$(_shrinkpath) \uf023" # lock icon
	else
		prompt_segment cyan black "$(_shrinkpath)"
	fi
}

# Virtual environment name
prompt_venv() {
	if [ -n "$PROMPT_VENV" ]; then
		[ -n "$VIRTUAL_ENV" ] && prompt_segment cyan black "[${VIRTUAL_ENV##*/}]"
	fi
}

# Git tracking and local status with git-prompt async plugin
prompt_git() {
	(($+commands[git])) || return # Stop host without git from continuing
	[ $UID -eq 0 ] && return # No git prompt for root user
	if [[ -n "$PROMPT_GIT" && "$gitrepo" == "true" ]]; then
		if [[ -n "$gitdirty" ]]; then # Dirty
			[ -n "$SSH_CLIENT" ] && print -n " %F{yellow}%}$(gitprompt)%{%f%}" && return
			prompt_segment yellow black
		else # Clean
			[ -n "$SSH_CLIENT" ] && print -n " %F{green}%}$(gitprompt)%{%f%}" && return
			prompt_segment green black
		fi
		if [[ -e "./.git/BISECT_LOG" ]]; then
			print -n "\uf977 " # script icon
		elif [[ -e "./.git/MERGE_HEAD" ]]; then
			print -n "\ue727 " # merge icon
		elif [[ -e "./.git/rebase" || -e "./.git/rebase-apply" || -e "./.git/rebase-merge" || -e "./.git/../.dotest" ]]; then
			print -n "\uf1c0 " # database icon
		else
			print -n "\ue725 " # branch icon
		fi
		print -n "$(gitprompt)" # git-prompt plugin
	fi
}

# Git dirty/clean status
prompt_git_dirty() {
	typeset -g gitdirty
	read -r gitdirty <&$1 # Read fd
	zle && zle .reset-prompt
	zle -F $1 # Call handler
	exec {1}<&- # Close fd
}

# Return code, cmd time, history line, job status, clock
prompt_status() {
	[ -n "$RPROMPT_ON" ] || return
   local symbols=()
	if [[ -n "$RPROMPT_RETURN" && -n $retcode && $retcode -ne 0 ]]; then # Return code
		[[ -n "$RPROMPT_RETURNSIG" && -z "$SSH_CLIENT" ]] && prompt_retsig
		[ -n "$SSH_CLIENT" ] && prompt_rsegment default 1 "\u21aa$retcode " || prompt_rsegment 1 11 "\u21aa$retcode "
	fi
	if [[ -n "$RPROMPT_CMDTIME" && -z $nocmdtime ]]; then # Command time (nocmdtime from accept-line widget)
		[ -n "$SSH_CLIENT" ] && local clockicon='' || local clockicon='\uf017 '
		prompt_humantime $timer_result
		[[ $timer_result -ge 3 && $timer_result -lt 15 ]] && symbols+=("%F{249}$clockicon${humant}")
		[[ $timer_result -ge 15 ]] && symbols+=("%F{249}$clockicon%F{9}$humant") # Red time
	fi
	if [ -n "$RPROMPT_HISTORY" ]; then # History line
		[ -n "$SSH_CLIENT" ] && prompt_rsegment default 245 "%h " || prompt_rsegment 245 default "%h "
	fi
	[ -n "$RPROMPT_CLOCK" ] && symbols+=("%F{249}%D{%H:%M:%S}") # 24H clock
	if [ -n "$SSH_CLIENT" ]; then
		[ "$jobnum" -gt 0 ] && symbols+=("[$jobnum]") # Number of jobs
	else
		[ "$jobnum" -eq 1 ] && symbols+=("%F{252}\uf013%f") # 1 job
		[ "$jobnum" -gt 1 ] && symbols+=("%F{252}\uf085%f") # >1 job
	fi
	if [ -n "${symbols[*]}" ]; then
		[ -n "$SSH_CLIENT" ] && prompt_rsegment default 23 "${symbols[*]}" || prompt_rsegment 235 default "${symbols[*]}"
	fi
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

# Return code names. If no match, then use return code number.
prompt_retsig() {
	case $retcode in
			-1)  retcode="FATAL(-1)" ;;
			1)   retcode="WARN(1)" ;;
			2)   retcode="BUILTINMISUSE(2)" ;;
			19)  retcode="STOP(19)" ;;
			20)  retcode="TSTP(20)" ;;
			21)  retcode="TTIN(21)" ;;
			22)  retcode="TTOU(22)" ;;
			126) retcode="CCANNOTINVOKE(126)" ;;
			127) retcode="CNOTFOUND(127)" ;;
			129) retcode="HUP(129)" ;;
			130) retcode="INT(130)" ;;
			131) retcode="QUIT(131)" ;;
			132) retcode="ILL(132)" ;;
			134) retcode="ABRT(134)" ;;
			136) retcode="FPE(136)" ;;
			137) retcode="KILL(137)" ;;
			139) retcode="SEGV(139)" ;;
			141) retcode="PIPE(141)" ;;
			143) retcode="TERM(143)" ;;
	esac
}

# Message of the day
prompt_motd() {
	[ -n "$SSH_CLIENT" ] && print "### [SSH] You have logged into $HOST ###" # SSH message
	if [[ $1 == "+greeting" ]]; then
		strftime -s hour %H $EPOCHSECONDS # Get hour of day
		local greeting
		# Display a greeting for the time of day. A random greeting is chosen from the array.
		(($hour >= 3  && $hour < 6)) && greeting=(Yawn "Back to bed?")
		(($hour >= 6  && $hour < 8)) && greeting=("Good morning" "Rise and shine")
		(($hour >= 8  && $hour < 12)) && greeting=("Good morning" Morning Hello Howdy)
		(($hour >= 12 && $hour < 18)) && greeting=("Good afternoon" Afternoon Greetings Hi)
		(($hour >= 0 && $hour < 3)) || (($hour >= 18 && $hour <= 23)) && greeting=("Good evening" Evening Hey "What's up")
		print "$greeting[RANDOM % $#greeting + 1] $USERNAME welcome to zsh"
		print "Look at the world, life itself is reason enough to exist. There's no meaning apart from the one we give it." # https://www.youtube.com/watch?v=-3frA_rj918&lc=UgxI05A4qsf77LylQ8p4AaABAg.8Whn3pcr1mA8n4H4rMvrV8
	fi
	# Show todo.txt todo list
	local todotxt="$ZSH"/todo.txt/todo.txt
	while read line; do # Store each line of todo list in an array
	    arr+=("$line")
	done < "$todotxt"
	if [[ -s "$todotxt" && -n "${arr[1]// }" ]]; then # File size not zero and first line not empty
		print " "; print "TODO:"
		for i in "${arr[@]}"; do
			print "$i"
		done
	fi
}

# Evaluate command
prompt_preexec() {
	typeset -ghi nextcmd lastcmd
	((nextcmd++))
	[ -n "$RPROMPT_CMDTIME" ] && typeset -g timer_sec=${timer_sec:-$EPOCHSECONDS}
}

# Execute before prompt
prompt_precmd() {
	typeset -g retcode=$? # Store return code
	typeset -g jobnum=$#jobstates # Number of jobs
	[[ -n "$PROMPT_GIT" && (($+commands[git])) ]] && { typeset -g gitrepo; read -r gitrepo < <(git rev-parse --is-inside-work-tree 2> /dev/null) } # Test if inside a git repo
	((nextcmd==lastcmd)) && unset retcode nextcmd lastcmd || ((lastcmd=nextcmd)) # Unset retcode if buffer is empty
	# Async git dirty status - Achieves prompt responsivness in large repos
	if [[ -n "$PROMPT_GIT" && (($+commands[git])) && "$gitrepo" == "true" ]]; then
		exec {FD}< <(git status -s) # Initialize file descriptor fd and fork git status
		zle -F $FD prompt_git_dirty # Handle input from fd
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
	if [ "$USER" != "$DEFAULTUSER" ]; then
		print -Pn "\e]1;%n: %c\a"
		print -Pn "\e]2;%n: %c\a"
	elif [ -n "$SSH_CLIENT" ]; then
		print -Pn "\e]1;%n@%m: %c\a"
		print -Pn "\e]2;%n@%m: %c\a"
	else
		print -Pn "\e]1;%c\a"
		print -Pn "\e]2;%c\a"
	fi
}

# Build prompt
prompt_build() {
	prompt_context
	prompt_venv
	prompt_dir
	prompt_git
	prompt_end
}

# Build rprompt
rprompt_build() {
	prompt_status
	prompt_rend
}

# Setup the things
prompt_setup() {
	autoload -Uz add-zsh-hook colors && colors
	add-zsh-hook preexec prompt_preexec
	add-zsh-hook precmd prompt_precmd
	[[ -n "$RPROMPT_CMDTIME" || -n "$PROMPT_MOTD" ]] && ! type strftime > /dev/null && { zmodload zsh/datetime } # Time module for cmdtime and motd
	[ "$USER" != "$DEFAULTUSER" ] && autoload -Uz _shrinkpath # Load shrinkpath function for other users

	# Display motd under prompt - function from fpath. Duration of message is set by TMOUT.
	if [[ -n "$PROMPT_MOTD" && $UID -ne 0 && ${TTY: -1} -eq 0 ]]; then
		if [ -n "$delaymotd" ]; then
			deploymsg @sleep:$delaymotd "$(prompt_motd +greeting)"
		else
			deploymsg "$(prompt_motd +greeting)"
		fi
	fi

	# Refresh prompt for ticking clock
	if [[ -n "$RPROMPT_ON" && -n "$RPROMPT_CLOCK" && -n "$RPROMPT_CLOCKTICK" ]]; then
		schedprompt() {
			local -i i=${"${(@)zsh_scheduled_events#*:*:}"[(I)schedprompt]}
			((i)) && sched -$i
			# Reset prompt unless a condition is met
			[[ $WIDGET = *(complete|delete|list|search)* || $ZLE_STATE = *(history|insert|overwrite)* \
				|| -n $paste || -n $__searching || -n $dmsg || -n $delaymotd ]] || { zle && zle .reset-prompt }
			sched +1 schedprompt # 1s schedule
		}
		schedprompt
	fi

	# Clear motd after timeout
	if [[ -n "$PROMPT_MOTD" && -n "$dmsg" ]]; then
		TMOUT=10 # Timeout for TRAPALRM in sec
		TRAPALRM() {
			[ -n "$RPROMPT_CLOCKTICK" ] && unset dmsg # Continue reset-prompt in schedprompt
			[[ -n "$SSH_CLIENT" || $WIDGET = *complete* || -n $delaymotd ]] || zle -M "" # Clear motd
			unset TMOUT
		}
	fi

	# Ctrl-C
	if [[ -n "$RPROMPT_RETURN" || -n "$RPROMPT_CLOCKTICK" ]]; then
		TRAPINT() {
			[ -n "$paste" ] && unset paste
			[ -n "$retcode" ] && unset retcode
			[ -n "$__searching" ] && unset __searching
			local ret
			((ret=128+$1))
			return ret # Restore return status
		}
	fi

	# Prompt
	PROMPT='%{%f%b%k%}$(prompt_build)'
	RPROMPT='%{%f%b%k%}$(rprompt_build)'
}

prompt_setup "$@"
