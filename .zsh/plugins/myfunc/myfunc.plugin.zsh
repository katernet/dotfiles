# dir stack
d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
compdef _dirs d

# Find file containing string
findstr() {
	if [[ $# == 1 ]]; then
		find . -type f -exec grep --exclude={.zsh_history} "$1" /dev/null {} \; # Current directory
	elif [[ $# == 2 ]]; then
		find "$1" -type f -exec grep --exclude={.zsh_history} "$2" /dev/null {} \; # Directory specified in 1st arg
	fi
}

# Backup file
bu() {
	if [[ $# == 1 ]] && [[ $1 == log ]]; then
		cat "$ZSH"/.zbulog # Print backup file log
	elif [[ $# == 1 ]] && [[ $1 == logclear ]]; then
		echo -n "" > "$ZSH"/.zbulog # Clear backup file log
		echo "Cleared backup log file."
	else
		mv "$1" "$1".bak_"$(date +%Y%m%d%H%M)" # Backup file with date in filename
		cp -ip "$1".bak_"$(date +%Y%m%d%H%M)" "$1" # Copy backup and use original filename
		if [[ $# == 2 ]] && [[ $2 == log ]]; then
			echo "$(date "+%Y-%m-%d %T") bu: $PWD/$1" >> "$ZSH"/.zbulog
		fi
	fi
}

# Git add file 1st arg, commit message 2nd arg and push.
gacp() {
	git add $1
	git commit -m $2
	git push
}

# Outputs name of current git branch
git_current_branch() {
	local ref
	ref=$(git symbolic-ref HEAD 2>/dev/null)
	if [[ $? != 0 ]]; then
		[[ $? == 128 ]] && return 0 # No git repo
		ref=$(git rev-parse --short HEAD 2> /dev/null) || return
	fi
	echo ${ref#refs/heads/}
}