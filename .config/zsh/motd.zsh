# Message of the day
_zmotd() {
	motdarr=()
	if [[ "$PROMPT_MOTDOPT" =~ 'hostinfo' ]]; then
		motdarr+=("$USER@$HOST $(uname -mrs)")
		motdarr+=("$(uptime)\n ")
	fi
	if [[ "$PROMPT_MOTDOPT" =~ 'greeting' ]]; then
		! type strftime > /dev/null && zmodload zsh/datetime
		strftime -s hour %H $EPOCHSECONDS # Get hour of day
		local greeting=()
		# Display a random greeting for the time of day
		(($hour >= 2  && $hour < 6)) && greeting=(Yawn "Back to bed?")
		(($hour >= 6  && $hour < 9)) && greeting=("Good morning" "Rise and shine")
		(($hour >= 9  && $hour < 12)) && greeting=("Good morning" Morning Hello Howdy)
		(($hour >= 12 && $hour < 18)) && greeting=("Good afternoon" Afternoon Greetings Hi)
		(($hour >= 18 && $hour <= 23)) || (($hour >= 0 && $hour < 2)) && greeting=("Good evening" Hey "What's up")
		motdarr+=("${greeting[RANDOM % $#greeting + 1]} $USER welcome to Zsh\n ")
	fi
	if [[ "$PROMPT_MOTDOPT" =~ 'help' ]]; then
		motdarr+=("/* Zsh Config Help */")
		motdarr+=("fns : Help page for functions included with zsh config")
		[[ "$OSTYPE" = darwin* ]] && motdarr+=("macfns : Help page for macOS functions")
		motdarr+=("zhelp : View help pages for Zsh")
		motdarr+=("Add a plugin to the zshrc plugin list: GitHubUser\/plugin OR ohmyzsh\/plugin")
		((!${+commands[fzf]})) && motdarr+=("Several functions use fzf - available from https://github.com/junegunn/fzf")
		motdarr+=("Prompt options help is available at https://github.com/katernet/dotfiles")
		motdarr+=("\-\-To mute this help message remove 'help' from MOTDOPT in zshrc\n ")
	fi
	# Display a 'meaningful' quote
	if [[ "$PROMPT_MOTDOPT" =~ 'quote' ]]; then
		if (($+commands[fortune])); then
			motdarr+=("${$(fortune -s)//$'\t'/ }\n ") # Fortune short quote. Param subst used to remove literal tab chars.
		fi
	fi
	# Show todo.txt todo list
	if [[ "$PROMPT_MOTDOPT" =~ 'todo' ]]; then
		if type todo.sh > /dev/null 2>&1; then
			local todotxt=$XDG_CONFIG_HOME/todo.txt/todo.txt
			if [ -s "$todotxt" ]; then # File not empty
				local todos=()
				while read line; do # Store each line of todo list in an array
					todos+=("$line")
				done < "$todotxt"
				if [ -n "${todos[1]// }" ]; then # First line not empty
					local n=1
					for t in "${todos[@]}"; do
						if [ "$n" -eq 1 ]; then
							motdarr+=("TODO:\n$t")
							unset n
						else
							motdarr+=("$t")
						fi
					done
				fi
			fi
		fi
	fi
}

zmotd() {
	for m in ${motdarr[@]}; do
		print "$m"
	done
}
