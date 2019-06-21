#!/bin/zsh

# Greeting #
if [[ $UID = 501 ]]; then # Only show greeting for user account
	uname -mnprs # Print OS Name, machine name, OS release, hardware name, architecture.
	uptime
fi

# Paths #
export PATH=/usr/local/bin:$PATH
export ZSH=/Users/$(id -nu 501)/.oh-my-zsh

# Prompt #
#PS1="%n@%m %F{green}%(5~|%-1~/…/%2~|%4~)%f $(git_prompt_info)%(?.%#.%F{red}%#%f) " # Disabled now in $ZSH/custom/themes/me.zsh-theme

# Theme #
ZSH_THEME="me"

# Plugins #
plugins=(git thefuck zsh-autosuggestions zsh-syntax-highlighting z)

# History #
HISTFILE="$ZSH/zfiles/.zsh_history"

# Disable compfix for root user #
[[ $UID = 0 ]] && ZSH_DISABLE_COMPFIX=true # https://github.com/robbyrussell/oh-my-zsh/issues/6939

# Sources #
source "$ZSH"/oh-my-zsh.sh

# Custom syntax highlighting #
ZSH_HIGHLIGHT_STYLES[globbing]=fg=99 # SlateBlue1
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=99

# Options #
unsetopt histverify # Disable confirmation in expansion

# zfiles #
compinit -i -d "$ZSH"/zfiles/zcompdump-$SHORT_HOST-$ZSH_VERSION
_Z_DATA="$ZSH/zfiles/.z"

# Aliases #
alias .="pwd"
alias l@="ls -al@"
alias zshrc="mate ~/.zshrc"
alias szshrc="source ~/.zshrc"
alias suroot="sudo -E -s"
alias {history,hist}=" fc -li 1 | less +G" # Space prevents write to history
alias -g G="| grep -i"
alias gs="git status"
alias gpom="git push origin master"
alias gpob="git push origin $(current_branch)"

# Mac
alias doff="pmset displaysleepnow; echo Display has been turned off!"
alias sleep="pmset sleepnow; echo Sleeping machine now!"
alias lock="/System/Library/CoreServices/Menu\ Extras/user.menu/Contents/Resources/CGSession -suspend"
alias pmsa="pmset -g assertions"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias ports="lsof -i -P"
alias rmdss="find . -name '.DS_Store' -print -delete"

# Goto
alias omz="~/.oh-my-zsh"
alias desk="~/Desktop"
alias apps="/Applications"
alias ~lib="~/Library"
alias lib="/Library"
alias ~prefs="~/Library/Preferences"
alias ~scripts="~/Library/Scripts"
alias scripts="/Library/Scripts/$(hostname)\ Scripts"
alias dreamer="/Volumes/Dreamer"
alias docs="/Volumes/Dreamer/Documents"
alias dl="/Volumes/Dreamer/Downloads"
alias dropbox="/Volumes/Dreamer/Documents/Dropbox"
alias stuff="/Volumes/Dreamer/Documents/Stuff"
alias backup="/Volumes/Reality"
alias latestbak="/Volumes/Reality/Backups.backupdb/$(hostname)/Latest"
alias clover="/Volumes/EFI/EFI/CLOVER"
alias tmpdir="'$TMPDIR'"
alias tmp="/private/tmp"

# Functions #
# Find file containing string
findstr() {
	if [[ $# == 1 ]]; then
		find . -type f -exec grep "$1" /dev/null {} \; # Current directory
	elif [[ $# == 2 ]]; then
		find "$1" -type f -exec grep "$2" /dev/null {} \; # Directory specified in 1st arg
	fi
}
# Backup file
bu() {
	if [[ $# == 1 ]]; then
		if [[ $1 == log ]]; then
			cat "$ZSH"/zfiles/filebackup.log # Print file backup log
		elif [[ $1 == logclear ]]; then
			rm "$ZSH"/zfiles/filebackup.log # Remove file backup log	
		else
			cp -ip "$1" "$1".backup_"$(date +%Y%m%d)" # Backup file with date in filename
		fi
	elif [[ $# == 2 ]] && [[ $1 == log ]]; then
		# Backup file with date in filename and log backup
		cp -ip "$2" "$2".backup_"$(date +%Y%m%d)" && echo "$(date "+%Y-%m-%d %T") bu: $PWD/$1" >> "$ZSH"/zfiles/zfilebackup.log
	fi
}
# Git add file 1st arg, commit message 2nd arg and push.
gacp() {
	git add "$1"
	git commit -m "$2"
	git push
}
