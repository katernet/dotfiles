# This module is for macOS only
if [[ "$OSTYPE" != darwin* ]]; then
	return
fi

# functions
fpath+=($ZDOTDIR/macos/fns)
autoload -Uz $ZDOTDIR/macos/fns/*(.:t) # Load all functions

# Preview files in Quick Look
ql() {
	(( $# > 0 )) && qlmanage -p "$@" &> /dev/null
}

# Delete .DS_Store files recursively. Default folder - .
rmdss() {
	find "${@:-.}" -type f -name ".DS_Store" -print -delete
}

# Spotify control AppleScript
if [[ (($+commands[svn])) && ! -f $ZDOTDIR/macos/SpotifyControl ]]; then # Install if requied
	( svn export https://github.com/dronir/SpotifyControl/trunk/SpotifyControl $ZDOTDIR/macos > /dev/null && \
		chmod u+x $ZDOTDIR/macos/SpotifyControl ) &!
fi
spotify() $ZDOTDIR/macos/SpotifyControl

# Aliases
alias l@='ls -lah@'
alias desk='~/Desktop'
alias apps='/Applications'
alias ~lib='~/Library'
alias lib='/Library'
alias ~prefs='~/Library/Preferences'
alias tmpdir='"$TMPDIR"'
alias tmp='/private/tmp'
alias doff='pmset displaysleepnow'
alias pmsg='pmset -g'
alias pmsa='pmset -g assertions'
alias flushdns='dscacheutil -flushcache'
alias killdns='sudo killall -HUP mDNSResponder'
alias ports='lsof -i -P'
alias cdf='cd "$(pfd)"'
alias pushdf='pushd "$(pfd)"'
alias ofd='open $PWD'
