# Navigation
alias .='pwd'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -- -='cd -'
for index ({1..9}) alias "$index"="cd -${index}"; unset index
alias l='ls -lah'
alias lt='ls -lAht'
alias lu='ls -lAhtu'
alias lR='ls -lahR'
alias ldir='ls -ldh */'

# Cmds
alias md='mkdir'
alias rd='rm -R'
alias _='sudo'
alias suroot='sudo -s'
alias m='micro'
alias ext='extract'
alias zshrc='$EDITOR $ZDOTDIR/.zshrc'
alias szshrc='source $ZDOTDIR/.zshrc'
alias hist='fc -li 1 | less +G'
alias h='history -i'
alias e='exit'
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
alias todo='todo.sh -d $ZDOTDIR/todo.txt/todo.cfg'
alias motd='dmsg "$(_motd)"'
alias tmux='tmux -f $HOME/.config/tmux/.tmux.conf'
alias benchzsh='hyperfine --shell $SHELL -- "$SHELL -i -c exit"'
alias benchwzsh='hyperfine --shell $SHELL --warmup 3 -- "$SHELL -i -c exit"'
(($+commands[htop])) && alias top='htop'
if [ -s $XDG_CONFIG_HOME/ssh/id_dsa ]; then
	typeset -g SSH_CONFIG="-F $XDG_CONFIG_HOME/ssh/config"
	typeset -g SSH_ID="-i $XDG_CONFIG_HOME/ssh/id_dsa"
	alias ssh="ssh $SSH_CONFIG $SSH_ID"
	alias ssh-copy-id="ssh-copy-id $SSH_ID"
elif [ -s $XDG_CONFIG_HOME/ssh/config ]; then
	typeset -g SSH_CONFIG="-F $XDG_CONFIG_HOME/ssh/config"
	alias ssh="ssh $SSH_CONFIG"
fi

# Goto
alias zd='$ZDOTDIR'
