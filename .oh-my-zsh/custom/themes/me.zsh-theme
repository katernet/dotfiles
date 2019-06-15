PROMPT='%n@%m %F{green}%(5~|%-1~/…/%2~|%4~)%f $(git_prompt_info)%(?.%#.%F{red}%#%f) '

ZSH_THEME_GIT_PROMPT_PREFIX="\ue725 %{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg[yellow]%}✚"
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg[white]%}§"
