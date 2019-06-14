#!/bin/zsh

# Greeting #
uname -mnprs # Print OS Name, machine name, OS release, hardware name, architecture.
uptime

# Paths #
export PATH=/usr/local/bin:$PATH
export ZSH="/Users/$USER/.oh-my-zsh"

# Prompt #
#PS1="%n@%m %F{green}%(5~|%-1~/…/%2~|%4~)%f $(git_prompt_info)%(?.%#.%F{red}%#%f) " # Disabled now in $ZSH/custom/themes/my.zsh-theme

# Theme #
ZSH_THEME="me"

# Plugins #
plugins=(git thefuck zsh-autosuggestions zsh-syntax-highlighting z)

# History #
HISTFILE="$ZSH/zfiles/.zsh_history"

# Sources #
source "$ZSH"/oh-my-zsh.sh
source "$ZSH"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Syntax highlighting #
ZSH_HIGHLIGHT_STYLES[globbing]=fg=99 # SlateBlue1

# zfiles #
compinit -d "$ZSH"/zfiles/zcompdump-$(hostname)-$ZSH_VERSION
_Z_DATA="$ZSH/zfiles/.z"

# Aliases #
alias .="pwd"
alias lsl="ls -l"
alias lsal="ls -al"
alias lsl@="ls -l@"
alias lsal@="ls -al@"
alias zshrc="mate ~/.zshrc"
alias szshrc="source ~/.zshrc"
alias history="fc -li 1"
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
