# This is the last zsh config script to be sourced
# Similar use case to .zlogin - sourced last in an interactive login shell

# Compile zsh config. Recompile if newer than compiled version.
zcmp() {
	# Zsh files and plugins
	local zfiles=(
		$ZDOTDIR/*.zsh
		$ZDOTDIR/plugins/**/*.zsh{,-theme}(N)
		$XDG_CACHE_HOME/zsh/zcompdump
	)
	for f in "${zfiles[@]}"; do
		[[ ! -f "$f".zwc || "$f" -nt "$f".zwc ]] && zcompile "$f"
	done
	# Function digests
	local zfns=($ZDOTDIR/fns)
	[[ "$OSTYPE" = darwin* ]] && zfns+=($ZDOTDIR/macos/fns) # macOS functions
	for f in "${zfns[@]}"; do
		[[ ! -f "$f".zwc || "$f" -nt "$f".zwc ]] && zcompile "$f" "$f"/*
	done
}

# MOTD
if [ "$PROMPT_MOTD" ]; then
	if [[ $UID -ne 0 && ${TTY:9} -eq 0 ]]; then # Not root and only in first TTY
		. $ZDOTDIR/motd.zsh
		# Fetch support
		[[ "$PROMPT_MOTDOPT" =~ 'neofetch' && ${+commands[neofetch]} ]] && neofetch || :
		[[ "$PROMPT_MOTDOPT" =~ 'fastfetch' && ${+commands[fastfetch]} ]] && fastfetch || :
		_zmotd # Build motd
		if [ ! -f $HISTFILE ]; then
			zmotd # Static motd
		else
			# Display motd in the zle status line - dmsg function from fpath
			dmsg "$(zmotd)"
			# Schedule zle status clear
			clearmotd() {
				if ! pgrep fzf > /dev/null; then # fzf not active
					[[ $WIDGET == *complete* ]] || { zle && zle -M "" }
				fi
				unset dm
			}
			sched +10 clearmotd # 10s
		fi
	fi
fi

[ "$PROMPT_COMPILE" ] && { zcmp &! } || :
