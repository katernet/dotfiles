# Plugin handler
# Adapted from https://github.com/mattmc3/zsh_unplugged

# Load plugins from zshrc plugin array
plgload() {
	integer i
	local repo plugin_name plugin_dir initfile initfiles instlmsg nogitmsg nosvnmsg
	typeset -g ZPLUGINDIR=${ZDOTDIR:-$HOME/.config/zsh}/plugins
	instlmsg="%B%F{2}▓▒░ $0:%f Installing plugins...%b"
	nogitmsg="%B%F{9}▓▒░ %F{220}$0: git not installed!%f%b"
	nosvnmsg="%B%F{9}▓▒░ %F{220}$0: svn not installed!%f%b"
	for repo in $@; do
		((i++))
		plugin_name=${repo:t}
		plugin_dir=$ZPLUGINDIR/$plugin_name
		initfile="$plugin_dir"/$plugin_name.plugin.zsh
		# Install plugin
		if [ ! -d "$plugin_dir" ]; then
			((! $+commands[git] )) && { print -P $nogitmsg; return 1 }
			[ $i -eq 1 ] && print -P $instlmsg
			if [[ ${repo:h} = 'ohmyzsh' ]]; then # Ohmyzsh plugins
				print "Pulling ohmyzsh plugin $plugin_name ..."
				svn export -q https://github.com/ohmyzsh/ohmyzsh/trunk/plugins/$plugin_name "$plugin_dir"
				((! $+commands[svn] )) && print -P $nosvnmsg
			else
				print "Cloning $repo ..."
				git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo "$plugin_dir"
			fi
			[ $i -eq ${#plugins[@]} ] && printf '\n'
		fi
		# Identify the init file
		if [[ ! -e $initfile ]]; then
			initfiles=("$plugin_dir"/*.plugin.{z,}sh(N) "$plugin_dir"/*.{z,}sh{-theme,}(N))
			[[ ${#initfiles[@]} -gt 0 ]] || { print >&2 "Plugin has no init file '$repo'." && continue }
			ln -sf "${initfiles[1]}" "$initfile"
		fi
		fpath+="$plugin_dir" # Add to fpath
		(( $+functions[zsh-defer] )) && zsh-defer . "$initfile" || . "$initfile" # Source plugin. Use zsh-defer if available.
	done
}

# Update plugins
plgupdate() {
	# Git plugins
	for d in $ZPLUGINDIR/*/.git(/); do
		print "Updating ${d:h:t} ..."
		command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
	done
	# Ohmyzsh plugins
	for p in "${plugins[@]}"; do
		if [[ $p =~ "ohmyzsh*" ]]; then
			local omzp=${p#ohmyzsh/}
			print "Updating ohmyzsh plugin $omzp ..."
			svn export -q --force https://github.com/ohmyzsh/ohmyzsh/trunk/plugins/$omzp $ZPLUGINDIR/$omzp
		fi
	done
}

# List plugin repos
plgrepo() {
	# Git plugins
	for d in $ZPLUGINDIR/*/.git; do
		git -C "${d:h}" remote get-url origin
	done
	# Ohmyzsh plugins
	for p in "${plugins[@]}"; do
		[[ "$p" =~ "ohmyzsh*" ]] && print "https://github.com/ohmyzsh/ohmzsh/tree/master/plugins/${p#ohmyzsh/}" || :
	done
}

# List loaded plugins
plglist() {
	for p in "${plugins[@]}"; do
		print "$p"
	done
}

# Load plugins
plgload $plugins

alias plgl='plglist'
alias plgr='plgrepo'
alias plgu='plgupdate'
