# Keybinds
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
bindkey '^[[3~'	delete-char			# [Del]- Forward delete
bindkey '^[[H'	beginning-of-line		# [Home]- Beginning of line
bindkey '^[[F'	end-of-line			# [End]- End of line
bindkey '^[[A'	up-line-or-beginning-search	# [Up]- History search up
bindkey '^[[B'	down-line-or-beginning-search	# [Down]- History search down

# History search with arrow keys
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Keybind functions
# For setting alt in macOS iTerm2 see https://www.iterm2.com/faq.html

# [Alt+L] - List files in an empty buffer, else use builtin down-case-word widget.
list_files() {
	if [[ -z "$BUFFER" ]]; then
		BUFFER="l"
		zle accept-line
	else
		zle down-case-word
	fi
}
zle -N list_files
bindkey '^[l' list_files

# [Alt+D] - Show dir stack below prompt
typeset -g dirmsg
show_dirs() {
	typeset -g dm=y
	POSTDISPLAY=$'\n'"${$(d)//$'\t'/       }"
}
zle -N show_dirs
bindkey '^[d' show_dirs

# [Alt+Enter] - Run fuzzy cd fpath function
fuzzy_cd() {
	zle -I
	fcd
}
zle -N fuzzy_cd
bindkey '^[^M' fuzzy_cd

# [Alt+S] - Run fuzzy file edit fpath function
fuzzy_editor() {
	zle -I
	fe
}
zle -N fuzzy_editor
bindkey '^[s' fuzzy_editor

# [Alt+R] - Fuzzy history search
fuzzy_hist() {
	(($+commands[fzy])) || { echo "Function requires: fzy" >&2 && return 1 }
	local tac
	[[ "$OSTYPE" == darwin* ]] && tac='tail -r' || tac='tac'
	BUFFER=$(history -n 1 | eval $tac | fzy)
	CURSOR=$#BUFFER
	builtin zle reset-prompt
}
zle -N fuzzy_hist
bindkey '^[r' fuzzy_hist

# [Ctrl+L] - Clear screen and unset prompt vars
clear_screen() {
	[ -n "$paste" ] 	&& unset paste
	[ -n "$exitcode" ] 	&& unset exitcode
	[ -n "$timer_result" ]  && unset timer_result
	[ -n "$__searching" ]   && unset __searching
	[ -n "$nocmdtime" ] 	&& unset nocmdtime
	[ -n "$histline" ]	&& unset histline
	[ -n "$dirmsg" ] 	&& unset dirmsg
	[ -n "$dm" ] 		&& unset dm
	builtin zle clear-screen
}
zle -N clear_screen
bindkey '^L' clear_screen

# [Ctrl+U] - Kill line and unset prompt vars
kill_line() {
	[ -n "$paste" ] 	&& unset paste
	[ -n "$__searching" ]   && unset __searching
	builtin zle kill-whole-line
}
zle -N kill_line
bindkey '^U' kill_line

# [Ctrl+Z] - Suspend and return job/buffer
fancy_ctrlz() {
	if [ $#BUFFER -eq 0 ]; then
		fg
		BUFFER=""
		builtin zle redisplay
	else
		builtin zle push-input
	fi
}
zle -N fancy_ctrlz
bindkey '^Z' fancy_ctrlz

# [Ctrl+X] - Prepend sudo to a command
prepend_sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
      BUFFER="sudo $BUFFER"
      CURSOR+=5
  fi
}
zle -N prepend_sudo
bindkey '^X' prepend_sudo

# [Ctrl+X,E] - Edit prompt in text editor
edit_cmdline() {
	# Set VISUAL to your preferred editor
	(($+commands[micro])) && local VISUAL='micro' || local VISUAL='vim'
	autoload edit-command-line
	edit-command-line
}
zle -N edit_cmdline
bindkey '^X^E' edit_cmdline

# [Ctrl+K] - Pgup half a page and keep scrollback
scroll_pgup() {
	local page
	((page=$LINES/2)) # Half of Terminal lines
	for i in {1..$page}; do
		print ''
	done
	tput cup $(($page-1)) # First line position is 0
}
zle -N scroll_pgup
bindkey '^K' scroll_pgup
