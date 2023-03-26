[[ "$TERM" != 'emacs' ]] || return

# Create a keybind hash
# Adapted from Debian system zshrc and https://wiki.archlinux.org/title/zsh#Key_bindings
typeset -A key
key=(
	BackSpace  "${terminfo[kbs]}"
	Home       "${terminfo[khome]}"
	End        "${terminfo[kend]}"
	Insert     "${terminfo[kich1]}"
	Delete     "${terminfo[kdch1]}"
	Up         "${terminfo[kcuu1]}"
	Down       "${terminfo[kcud1]}"
	Left       "${terminfo[kcub1]}"
	Right      "${terminfo[kcuf1]}"
	PageUp     "${terminfo[kpp]}"
	PageDown   "${terminfo[knp]}"
	Shift-Tab  "${terminfo[kcbt]}"
)

bindkeymap() {
	local i sequence widget
	local -a maps
	while [[ "$1" != "--" ]]; do
		maps+=( "$1" )
		shift
	done
	shift
	sequence="${key[$1]}"
	widget="$2"
	[[ -z "$sequence" ]] && return 1
	for i in "${maps[@]}"; do
		bindkey -M "$i" "$sequence" "$widget"
	done
}

bindkeymap emacs             -- BackSpace   backward-delete-char
bindkeymap       viins       -- BackSpace   vi-backward-delete-char
bindkeymap             vicmd -- BackSpace   vi-backward-char
bindkeymap emacs             -- Home        beginning-of-line
bindkeymap       viins vicmd -- Home        vi-beginning-of-line
bindkeymap emacs             -- End         end-of-line
bindkeymap       viins vicmd -- End         vi-end-of-line
bindkeymap emacs viins       -- Insert      overwrite-mode
bindkeymap             vicmd -- Insert      vi-insert
bindkeymap emacs             -- Delete      delete-char
bindkeymap       viins vicmd -- Delete      vi-delete-char
bindkeymap emacs viins vicmd -- Up          up-line-or-history
bindkeymap emacs viins vicmd -- Down        down-line-or-history
bindkeymap emacs             -- Left        backward-char
bindkeymap       viins vicmd -- Left        vi-backward-char
bindkeymap emacs             -- Right       forward-char
bindkeymap       viins vicmd -- Right       vi-forward-char
bindkeymap emacs viins       -- Shift-Tab   reverse-menu-complete
bindkeymap emacs viins       -- PageUp	    forward-word
bindkeymap emacs viins       -- PageDown    backward-word
bindkeymap emacs viins       -- -s '^q'     push-line

# Make sure the terminal is in application mode when zle is active
# Only then are the values from $terminfo valid
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	key_start() {
		emulate -L zsh
		printf '%s' ${terminfo[smkx]}
	}
	key_end() {
		emulate -L zsh
		printf '%s' ${terminfo[rmkx]}
	}
fi

unfunction bindkeymap

# History search keybinds
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Keybind functions
# Mac users: for using alt in Term2 see https://www.iterm2.com/faq.html

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
show_dirs() {
	dmsg "${$(d)//$'\t'/       }"
}
zle -N show_dirs
bindkey '^[d' show_dirs

# [Alt+G] - Run fuzzy dir stack cd function
fuzzy_dirs() {
	zle -I
	fd
}
zle -N fuzzy_dirs
bindkey '^[g' fuzzy_dirs

# [Alt+Enter] - Run fuzzy dir stack fpath function
fuzzy_cd() {
	zle -I
	fd
}
zle -N fuzzy_cd
bindkey '^[^M' fuzzy_cd

# [Alt+S] - Run fuzzy file edit fpath function
fuzzy_editor() {
	zle -I
	fe
	if [ "$RESULT" ]; then
		LBUFFER="$EDITOR $RESULT"
		builtin zle accept-line
		unset RESULT
	fi
}
zle -N fuzzy_editor
bindkey '^[s' fuzzy_editor

# [Alt+R] - Fuzzy history search
fuzzy_hist() {
	(($+commands[fzf])) || { echo "Function requires: fzf" >&2 && return 1 }
	local tac
	[[ "$OSTYPE" == darwin* ]] && tac='tail -r' || tac='tac'
	BUFFER=$(history -n 1 | eval $tac | fzf)
	CURSOR=$#BUFFER
	builtin zle reset-prompt
}
zle -N fuzzy_hist
bindkey '^[r' fuzzy_hist

# [Ctrl+L] - Clear screen replacement to unset prompt vars
clear_screen() {
	[ "$paste" ]	    	&& unset paste
	[ "$exitcode" ]	    	&& unset exitcode
	[ "$timer_result" ]	&& unset timer_result
	[ "$__searching" ]	&& unset __searching
	[ "$nocmdtime" ]	&& unset nocmdtime
	[ "$histline" ]		&& unset histline
	[ "$dirmsg" ]		&& unset dirmsg
	[ "$dm" ]		&& unset dm
	# Redraw prompt to prevent transient new line
	[[ "$PROMPT_TRANSIENTOPT" =~ 'newline' ]] && prompt_setup "$@"
	zle clear-screen
}
zle -N clear_screen
bindkey '^L' clear_screen

# [Ctrl+U] - Kill line and unset prompt vars
kill_line() {
	[ "$paste" ] && unset paste
	[ "$__searching" ] && unset __searching
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

# [Ctrl+X] - Prepend sudo to prompt
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
	autoload edit-command-line
	edit-command-line
}
zle -N edit_cmdline
bindkey '^X^E' edit_cmdline

# [Ctrl+K] - Pgup half a page and keep scrollback
scroll_pgup() {
	local pg pos
	# Read position of cursor. Adapted from https://stackoverflow.com/a/43911767/5798232
	echo -ne '\e[6n' > /dev/tty	    # Ask the terminal for the position
	read -t 1 -s -r -d\[ pos < /dev/tty # Garbage
	read -t 1 -s -r -d R pos < /dev/tty # Cursor position
	pos=${pos//;*}
	((pg=$LINES/2)) 	  # Half of Terminal lines
	(($pos <= $pg)) && return # Cursor position is already half a page
	for i in {1..$pg}; do
		print ''
	done
	tput cup $(($pg-1)) # Set the cursor position to half a page
	builtin zle reset-prompt
}
zle -N scroll_pgup
bindkey '^K' scroll_pgup
