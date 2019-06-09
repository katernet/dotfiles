local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='%n@%m %{%F{green}%}%(5~|%-1~/…/%2~|%4~) %{%f%}% $(git_prompt_info)%% '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[blue]%}) %{$fg[yellow]%}✚"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}) %{$fg[white]%}§"
