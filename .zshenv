# Path #
typeset -U path
path=(/usr/local/{bin,sbin} $path)
export PATH

# Dirs #
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Env #
export GPG_TTY=$TTY						# Set GnuPG TTY
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg				# GnuPG config path
export MACHINE_STORAGE_PATH=$XDG_DATA_HOME/docker-machine	# Docker machine path
