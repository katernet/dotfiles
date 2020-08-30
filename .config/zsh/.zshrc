# Interactive only #
[[ -o interactive ]] || return

# Prompt opt #
PROMPT_CLOCK=y
PROMPT_HISTLINE=y
PROMPT_ICONS=y
PROMPT_TRANSIENT=y
PROMPT_TRANSIENTOPT=(clock histline)
PROMPT_DIRTRIM=y
PROMPT_DIRLOCK=y
PROMPT_DOCKER=y
PROMPT_GIT=y
PROMPT_BOLD=y
PROMPT_TITLES=y
PROMPT_CLOCKTICK=y
PROMPT_EXIT=y
PROMPT_MOTD=y
RPROMPT_CMDTIME=y
RPROMPT_EXITCODE=y
RPROMPT_EXITSIG=y

# fpath #
fpath=($ZDOTDIR/fns $fpath)
autoload -Uz $ZDOTDIR/fns/*(.:t) # Load all functions

# Source #
source $ZDOTDIR/init.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/comp.zsh
source $ZDOTDIR/keybinds.zsh
source $ZDOTDIR/macos/macos.zsh
source $ZDOTDIR/alias.zsh
