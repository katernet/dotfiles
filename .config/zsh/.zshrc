# Prompt opt
#PROMPT_CONTEXT=u
#PROMPT_CLOCK=y
#PROMPT_HISTLINE=y
PROMPT_BOLD=y
#PROMPT_PREFIX=y
PROMPT_ICONS=y
#PROMPT_OS=y
#PROMPT_NEWLINE=y
PROMPT_TRANSIENT=y
PROMPT_TRANSIENTOPT=(newline clock hist)
PROMPT_DIR=trim
#PROMPT_DIRRESUME=y
PROMPT_DIRLOCK=y
#PROMPT_DIRCOLOR=default
#PROMPT_CHAR=❯
#PROMPT_CHARCOLOR=green
#PROMPT_DOCKER=y
#PROMPT_GITVCS=y
PROMPT_VENV=y
PROMPT_TITLES=y
#PROMPT_CLOCKTICK=y
#PROMPT_CLOCKEXE=y
PROMPT_EXIT=y
PROMPT_EXITRESET=y
PROMPT_MOTD=y
PROMPT_MOTDOPT=(help greeting quote todo)
#PROMPT_BOTTOM=y
PROMPT_COMPILE=y
PROMPT_ZHELP=xman
#RPROMPT_OFF=y
#RPROMPT_CLOCK=y
RPROMPT_CMDTIME=y
#RPROMPT_HISTLINE=y
RPROMPT_DOCKER=Y
RPROMPT_GITVCS=Y
RPROMPT_JOBS=y
RPROMPT_EXITCODE=y
RPROMPT_EXITSIG=y

# Plugins
plugins=(
	romkatv/zsh-defer # Plugins below are deferred until the shell loads
	ohmyzsh/git
	laggardkernel/zsh-thefuck
	marzocchi/zsh-notify
	zdharma-continuum/fast-syntax-highlighting
	zsh-users/zsh-autosuggestions
)

# Scripts
. $ZDOTDIR/init.zsh
. $ZDOTDIR/plgload.zsh
. $ZDOTDIR/comp.zsh
. $ZDOTDIR/prompt.zsh
. $ZDOTDIR/gitvcs.zsh
. $ZDOTDIR/keybinds.zsh
. $ZDOTDIR/macos/macos.zsh
. $ZDOTDIR/alias.zsh
. $ZDOTDIR/login.zsh
