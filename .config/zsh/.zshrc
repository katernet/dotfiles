# Prompt opt
PROMPT_BOLD=y
PROMPT_ICONS=y
PROMPT_TRANSIENT=y
PROMPT_TRANSIENTOPT=(newline clock hist)
PROMPT_DIR=trim
PROMPT_DIRRESUME=y
PROMPT_DIRLOCK=y
PROMPT_VENV=y
PROMPT_TITLES=y
PROMPT_EXIT=y
PROMPT_EXITRESET=y
PROMPT_MOTD=y
PROMPT_MOTDOPT=(help greeting quote todo)
PROMPT_COMPILE=y
PROMPT_ZHELP=xman
RPROMPT_CMDTIME=y
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
