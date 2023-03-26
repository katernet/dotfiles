# This module is for macOS only
[[ "$OSTYPE" = darwin* ]] || return

# Terminal colors
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Preview files in Quick Look
ql() {
	(( $# > 0 )) && qlmanage -p "$@" &> /dev/null
}

# Delete .DS_Store files recursively. Default folder: pwd
rmdss() {
	find "${@:-.}" -type f -name ".DS_Store" -delete -print 2>&1 | grep -v "Operation not permitted"
}

# Spotify control AppleScript - https://github.com/dronir/SpotifyControl
spotify() {
	[ -x "$ZDOTDIR/macos/SpotifyControl" ] && { $ZDOTDIR/macos/SpotifyControl "$@" && return }
	# Download if required
	# You may wish to remove the below code and download manually
	if (($+commands[svn])); then
		svn export --quiet https://github.com/dronir/SpotifyControl/trunk/SpotifyControl $ZDOTDIR/macos
		chmod u+x $ZDOTDIR/macos/SpotifyControl
		$ZDOTDIR/macos/SpotifyControl "$@"
	else
		print "$0: svn required to download spotify plugin!" >&2 && return 1
	fi
}

# Complete help keybind replacement for xman - [Esc+H]
if [ "$PROMPT_ZHELP" = 'xman' ] && (( ${+functions[xman]} )); then
	complete_help() {
		[ ! -f "$HELPDIR"/$BUFFER ] && xman $BUFFER || zhelp $BUFFER
		unset BUFFER
		zle accept-line
	}
	zle -N complete_help
	bindkey '^[h' complete_help
fi

# Lock screen
# Require to allow the Terminal in macOS Accessibility security preferences
# Keyboard shortcut has been modified - macOS default is command+control+Q
lock() osascript -e 'tell application "System Events" to keystroke "l" using {command down,option down}'

# Aliases
alias l@='ls -lah@'				 # ls ext attributes
alias ldc='ls -lahU'				 # ls date created
alias afk='lock'				 # Lock screen
alias spot='spotify'				 # Spotify short alias
alias doff='pmset displaysleepnow' 		 # Sleep display
alias pmsg='pmset -g' 				 # List power settings
alias pmsa='pmset -g assertions' 		 # List power assertions
alias flushdns='dscacheutil -flushcache' 	 # Flush DNS
alias killdns='sudo killall -HUP mDNSResponder'  # Relaunch DNS
alias ports='lsof -ni -s TCP:LISTEN,ESTABLISHED' # List open ports
alias cdf='cd "$(pfd)"' 			 # cd to current Finder directory
alias pushdf='pushd "$(pfd)"' 			 # Add current Finder directory to dir stack
alias ofd='open .' 				 # Open current directory in Finder
[ "$PROMPT_ZHELP" = 'xman' ] && alias man='xman' # Use xman fn in place of man command
(($+commands[trash])) && alias trash='trash -F'  # Use trash cli with Finder integration
(($+commands[trash])) && alias del='trash'

# Hash dirs
hash -d apps=/Applications
hash -d lib=~/Library
hash -d prefs=~/Library/Preferences
hash -d tmpdir=$TMPDIR
