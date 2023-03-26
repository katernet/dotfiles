# Asynchronous git vcs module
# Adapted from https://www.bitinvert.com/dotfiles/ps1-prompt

local giticon stgicon ustgicon utricon ahdicon bhdicon stsicon

if [ "$PROMPT_ICONS" ]; then
	giticon='\ue725 ' # branch
	stgicon='\ueb8a'  # dot
	usticon='\uf4a7'  # plus
	utricon='\uf6d7'  # 3 dots
	ahdicon='\u21e1'  # up arrow
	bhdicon='\u21e3'  # down arrow
	stsicon='\uf73a'  # flag
else
	stgicon='+'
	usticon='!'
	utricon='?'
	ahdicon='∧'
	bhdicon='∨'
	stsicon='S'
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats '%b%c%u%m'
zstyle ':vcs_info:git*' actionformats '(%a) %b%c%u%m'
zstyle ':vcs_info:git*' stagedstr "$stgicon"
zstyle ':vcs_info:git*' unstagedstr "$usticon"
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*+set-message:*' hooks no-vcs git-rev git-stash git-dirty

# Show remote ref name and number of commits ahead or behind
+vi-git-rev() {
	local ahead behind remote branch on_branch detached_from
	local -a gitinfo
	# If hook_com[revision] is already short then we can skip safely getting the short hash
	[[ "${#hook_com[revision]}" -gt 39 ]] && hook_com[revision]="$(command git rev-parse --verify -q --short=7 HEAD)"
	# On a branch? Need to check because hook_com[branch] might be a tag
	IFS='' read -r branch < "${gitdir}/HEAD"
	[[ "$branch" = "ref: refs/heads/"* ]] && on_branch=true || on_branch=false
	if [[ "$on_branch" = true ]]; then
		IFS=$'\t' read -r ahead behind <<<"$(command git rev-list --left-right --count HEAD...@{u})"
		(( ahead )) && gitinfo+=( "${ahdicon}${ahead}" )
		(( behind )) && gitinfo+=( "${bhdicon}${behind}" )
		hook_com[branch]="${hook_com[branch]}${gitinfo:+${(j:/:)gitinfo}}"
	else
		detached_from="${$(command git describe --all --always 2> /dev/null):-${hook_com[revision]}}"
		hook_com[branch]="detached from ${detached_from}"
	fi
}

# Show count of stashed changes
+vi-git-stash() {
	local stashes stashes_exit stash_message
	stashes="$(command git rev-list --walk-reflogs --count refs/stash 2> /dev/null)"
	stashes_exit="$?"
	[ "$stashes_exit" -ne 0 ] && return
	[ "$stashes" -eq 0 ] && return
	stash_message="(${stashes} stashed)"
	hook_com[misc]+="${hook_com[misc]}${hook_com[misc]:+} ${stsicon}"
}

# Colorize git vcs based on dirty status and display untracked files
+vi-git-dirty() {
	local gitcolor
	local -a gitstatus
	gitstatus=("${(f)$(command git status -s)}") # Param expn f: split at new lines
	for s in "${gitstatus[@]}"; do
		if [[ "${s:0:2}" =~ '( A| D| M| U|\?)' ]]; then
			gitcolor='yellow'
			break
		else
			gitcolor='green'
		fi
	done
	hook_com[branch]="%F{$gitcolor}${giticon}${hook_com[branch]}"
	[[ "$gitstatus" =~ '\?' ]] && hook_com[unstaged]+="$utricon%f"
}

# No vcs detected
+vi-git-no-vcs() { return }

# Asynchronous handlers
async_vcs_info() {
	setopt local_options no_monitor
	if [[ "$_async_vcs_info_pid" -ne 0 ]]; then
		 zle -F "$_async_vcs_info_fd"
		 # Clean up the old fd
		 exec {_async_vcs_info_fd}<&-
		 unset _async_vcs_info_fd
		 # Kill the obsolete async child
		 kill -s HUP "$_async_vcs_info_pid" &> /dev/null
	fi
	coproc {
		vcs_info
		print "$vcs_info_msg_0_"
	}
	_async_vcs_info_pid=$! # Get the pid of the vcs_info coproc
	exec {_async_vcs_info_fd}<&p # Get the vcs_info coproc output fd
	disown %?vcs_info # disown "coproc
	zle -F $_async_vcs_info_fd async_vcs_info_handle_complete
}

async_vcs_info_handle_complete() {
	zle -F $1 # Unregister the handler
	local old_vcs_info_msg_0_="$vcs_info_msg_0_"
	vcs_info_msg_0_="$(<&$1)"  # Read the vcs_info data
	exec {1}<&- # Clean up the old fd
	unset _async_vcs_info_fd
	unset _async_vcs_info_pid
	if [ "$old_vcs_info_msg_0_" != "$vcs_info_msg_0_" ]; then
		zle && zle .reset-prompt # Redraw prompt using builtin widget
	fi
}

# Clear the vcs info
clear_vcs_info() { unset vcs_info_msg_0_ }

# Hooks
precmd_functions+=(async_vcs_info)
chpwd_functions+=(clear_vcs_info)
