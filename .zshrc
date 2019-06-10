# Greeting #
uname -mnprs # Print OS Name, machine name, OS release, hardware name, architecture.
uptime

# Paths #
export PATH=/usr/local/bin:$PATH
export ZSH="/Users/$USER/.oh-my-zsh"

# Prompt #
#PS1="%n@%m %{%F{green}%}%(5~|%-1~/…/%2~|%4~) %{%f%}%% " # Disabled now in ~/.oh-my-zsh/themes/robbyrussell.zsh-theme

# Theme #
ZSH_THEME="robbyrussell"

# Plugins #
plugins=(git thefuck zsh-autosuggestions zsh-syntax-highlighting)

# Source #
source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Syntax highlighting #
ZSH_HIGHLIGHT_STYLES[globbing]=fg=99 # SlateBlue1

# History timestamp #
HIST_STAMPS="yyyy-mm-dd"

# Change zcompdump dir #
compinit -d ~/.oh-my-zsh/zcompdump/zcompdump-$(hostname)-$ZSH_VERSION

# Aliases #
alias zshrc="nano ~/.zshrc"

# Cmds
alias lsl="ls -l"
alias lsal="ls -al"
alias lsl@="ls -l@"
alias .="pwd"
alias ..="cd .."
alias ...="cd ../../"
alias doff="pmset displaysleepnow; echo Display has been turned off!"
alias sleep="pmset sleepnow; echo Sleeping machine now!"
alias lock="/System/Library/CoreServices/Menu\ Extras/user.menu/Contents/Resources/CGSession -suspend"
alias pmsa="pmset -g assertions"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias ports="lsof -i -P"
alias -g G="| grep -i" 
alias g="git"
alias ga="git add"
alias gs="git status"
alias gp="git push"
alias gpom="git push origin master"
alias gf="git fetch"
alias gfo="git fetch origin"
alias gcm="git commit -m"

# Goto
alias /="cd /"
alias ~="cd ~"
alias desk="cd ~/Desktop"
alias apps="cd /Applications"
alias ~lib="cd ~/Library"
alias lib="cd /Library"
alias ~prefs=" cd ~/Library/Preferences"
alias prefs="cd /Library/Preferences"
alias ~scripts="cd ~/Library/Scripts"
alias scripts="cd "/Library/Scripts/$(hostname) Scripts""
alias soul="cd /"
alias dreamer="cd /Volumes/Dreamer"
alias docs="cd /Volumes/Dreamer/Documents"
alias dl="cd /Volumes/Dreamer/Downloads"
alias downloads="cd /Volumes/Dreamer/Downloads"
alias dropbox="cd /Volumes/Dreamer/Documents/Dropbox"
alias stuff="cd /Volumes/Dreamer/Documents/Stuff"
alias backup="cd /Volumes/Reality"
alias latestbak="cd /Volumes/Reality/Backups.backupdb/$(hostname)/Latest"
alias clover="cd /Volumes/EFI/EFI/CLOVER"
alias tmpdir="cd $TMPDIR"
alias tmp="cd /private/tmp"
