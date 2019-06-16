# Prompt
PS1='%n@%m %F{green}%(5~|%-1~/…/%2~|%4~)%f $(git_prompt_info)%(?.%#.%F{red}%#%f) '

# Outputs current git branch info into prompt
function git_prompt_info() {
  local ref
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
	 ref=$(command git symbolic-ref HEAD 2>/dev/null) || \
	 ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/} $(git_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks status of working tree
function git_status() {
  local STATUS=$(git status --porcelain 2>/dev/null)
  if $(echo "$STATUS" | grep '^A ' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_ADDED"
  elif $(echo "$STATUS" | grep '^M ' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_ADDED"
  elif $(echo "$STATUS" | grep '^MM ' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_ADDED"
  elif $(echo "$STATUS" | grep '^U ' &>/dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_UNMERGED"
  elif [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="\ue725 %{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[yellow]%}✚"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[white]%}§"

