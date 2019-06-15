#!/bin/zsh

DIR=~/.brew # Init directory

if [ ! -d ~/.brew ]; then
	mkdir ~/.brew
fi

case "$1" in
backup)
	/usr/local/bin/brew leaves > $DIR/brews # Backup brew dependencies packages
	/usr/local/bin/brew cask list > $DIR/casks # Backup brew casks
	;;
	
restore)
	# Install packages from backup
	installBrews() {
		printf "\nInstalling brews...\n"
		for i in $(cat $DIR/brews); do # For all packages
			if ! /usr/local/bin/brew ls --versions $i; then # Check if package installed
				/usr/local/bin/brew install $i # Install brew package
			fi
		done
		printf "\nInstalled brews!\n"
	}
	
	# Install casks from backup
	installCasks() {
		printf "\nInstalling casks...\n"
		brew tap homebrew/cask-fonts # Tap into font caskroom
		for i in $(cat $DIR/casks); do
			if ! sudo -u rich brew cask list --versions $i; then
				/usr/local/bin/brew cask install $i # Install cask
			fi
		done
		printf "\nInstalled casks!\n"
	}

	# Check for Homebrew, install if we don't have it.
	if test ! $(which brew); then
		read -p "Install Homebrew and your brew apps? [y/n] " prompt
		if [[ $prompt =~ [yY](es)* ]]; then
			printf "\nInstalling Homebrew...\n"
			ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
			printf "\nHomebrew installed!\n"
		
			installBrews
			installCasks
		fi
	else
		installBrews
		installCasks
		usr/local/bin/brew cleanup -s # Cleanup old versions of installed formulae and scrub cache
	fi
	;;
esac

