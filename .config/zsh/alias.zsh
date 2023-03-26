# Navigation
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -- -='cd -'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
alias l='ls -lah'
alias lt='ls -lAht'
alias lu='ls -lAhtu'
alias lR='ls -lahR'
alias ldir='ls -ldh */(N)' 		# List directories only
alias lbig='ls -flh *(.OL[1,10])' 	# List 10 largest files
alias lsmall='ls -rSlh *(.oL[1,10])' 	# List 10 smallest files
alias lnew='ls -tlh *(D.om[1,10])' 	# List 10 newest files
alias lold='ls -tlh *(D.Om[1,10])' 	# List 10 oldest files
[[ "$OSTYPE" = linux* ]] && alias ls='ls --color=auto'

# Cmds
#alias rm='rm -i'
#alias mv='mv -i'
#alias cp='cp -Ri'
#alias rd='rm -Ri'
alias md='mkdir'
alias mkcd='take'
alias _='sudo'
alias suroot='sudo -Es'
alias m='micro'
alias extract='ext'
alias h='history -i'
alias e='exit'
alias incognito=' hist incognito'
alias ghost=' hist ghost'
alias -g G='| grep --color=auto -i'
alias -g LG='| less +G'
alias -g DN='> /dev/null 2>&1'
alias -g X='| xargs'
alias py='python3'
alias gs='git status'
alias gpom='git push origin master'
alias gpob='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias dk='docker'
alias dm='docker-machine -s $MACHINE_STORAGE_PATH'
alias todo='todo.sh -d $XDG_CONFIG_HOME/todo.txt/todo.cfg'
alias motd='zmotd'
(($+commands[htop])) && alias top='htop'
[ -d $XDG_CONFIG_HOME/tmux ] && alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf" 
if [ -s $XDG_CONFIG_HOME/ssh/id_dsa ]; then # Custom ssh config location
	typeset -g SSH_CONFIG="-F $XDG_CONFIG_HOME/ssh/config"
	typeset -g SSH_ID="-i $XDG_CONFIG_HOME/ssh/id_dsa"
	alias ssh="ssh $SSH_CONFIG $SSH_ID"
	alias ssh-copy-id="ssh-copy-id $SSH_ID"
elif [ -s $XDG_CONFIG_HOME/ssh/config ]; then
	typeset -g SSH_CONFIG="-F $XDG_CONFIG_HOME/ssh/config"
	alias ssh="ssh $SSH_CONFIG"
fi

# Hash dirs
hash -d desk=~/Desktop
hash -d docs=~/Documents
hash -d dl=~/Downloads
hash -d localbin=/usr/local/bin
hash -d tmp=/tmp
hash -d config=$XDG_CONFIG_HOME
hash -d cache=$XDG_CACHE_HOME
hash -d data=$XDG_DATA_HOME
hash -d zd=$ZDOTDIR
hash -d zfns=$ZDOTDIR/fns
hash -d zmacfns=$ZDOTDIR/macos/fns
hash -d zplugins=$ZDOTDIR/plugins
hash -d zcache=$XDG_CACHE_HOME/zsh
