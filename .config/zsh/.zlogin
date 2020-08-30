# Compile zsh files. Recompile files if newer than compiled version.

zshcmp() {
	setopt local_options extendedglob null_glob
	local zfiles=(
		"$1"/(.z*~*.zcomp*~*.zwc|*.zsh)	# All .z* and .zsh files except compdump and .zwc
		"$1"/*/*.zsh			# All .zsh files in child directories
	)
	for i in "${zfiles[@]}"; do
		[[ ! -f "$i".zwc || "$i" -nt "$i".zwc ]] && zcompile "$i" &!
	done
}

# Compile config files
zshcmp $ZDOTDIR 2> /dev/null

# Deploy silent background job
[ -n "$PROMPT_RJOB" ] && sjob

# Message of the day below the prompt
_motd() {
	[ -n "$nomotd" ] && return
	local motdarr=()
	if [[ ! $@ =~ "-histstatus" ]]; then
		if [ -n "$PROMPT_HISTOFF" ]; then
			motdarr+=("HIST OFF")
		elif [ -n "$PROMPT_HISTDISABLE" ]; then
			motdarr+=("HISTDISABLE ON")
		fi
	fi
	if [[ ! $@ =~ "-greeting" ]]; then
		strftime -s hour %H $EPOCHSECONDS # Get hour of day
		local greeting=()
		# Display a greeting for the time of day. A random greeting is chosen from the array.
		(($hour >= 3  && $hour < 6)) && greeting=(Yawn "Back to bed?")
		(($hour >= 6  && $hour < 8)) && greeting=("Good morning" "Rise and shine")
		(($hour >= 8  && $hour < 12)) && greeting=("Good morning" Morning Hello Howdy)
		(($hour >= 12 && $hour < 18)) && greeting=("Good afternoon" Afternoon Greetings Hi)
		(($hour >= 18 && $hour <= 23)) || (($hour >= 0 && $hour < 3)) && greeting=("Good evening" Evening Hey "What's up")
		motdarr+=("${greeting[RANDOM % $#greeting + 1]} $USERNAME welcome to zsh.")
	fi
	# Display a 'meaningful' quote
	if [[ ! $@ =~ "-quote" ]]; then
		motdarr+=(${"$(fortune -s)"//$'\t'/ }) # Fortune short quote. Param subst used to remove literal tab chars.
	fi
	# Show todo.txt todo list
	if [[ ! $@ =~ "-todo" ]]; then
		if type todo.sh > /dev/null 2>&1; then 
			local todotxt=$ZDOTDIR/todo.txt/todo.txt
			if [ -s "$todotxt" ]; then # File not empty
				local todos=()
				while read line; do # Store each line of todo list in an array
					todos+=("$line")
				done < "$todotxt"
				if [ -n "${todos[1]// }" ]; then # First line not empty
					local n
					for t in "${todos[@]}"; do
						((n++))
						((n=1)) && motdarr+=("TODO:\n$t") || motdarr+=($t)
					done
					unset n
				fi
			fi
		fi
	fi
	for i in ${motdarr[@]}; do
		print $i
		print " "
	done
}

if [[ -n "$PROMPT_MOTD" && $UID -ne 0 && ${TTY: -1} -eq 0 ]]; then
	# Display motd using dmsg function from fpath
	# To remove a section supply an -arg to _motd - arg: -histstatus -greeting -quote -todo
	dmsg "$(_motd)"
	# Clear motd after timeout
	if [ -n "$dm" ]; then
		TMOUT=10 # Timeout for TRAPALRM
		TRAPALRM() {
			[ -n "$PROMPT_CLOCKTICK" ] && unset dm # Continue reset-prompt in schedprompt
			[[ $WIDGET == *complete* ]] || zle -M "" # Clear motd
			unset TMOUT
		}
	fi
fi
