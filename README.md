# dotfiles

My dotfiles

Feel free to use them as needed.

<p align="center">
  <img src="https://images2.imgbox.com/c6/e9/XIEL2lPX_o.png"/>
  Left: Transient Prompt off Right: Transient Prompt
</p>

### 🖥 zsh

A custom zshrc framework, including a spaceship like prompt theme with an async git status and plugin support.

The shell loads in 0.02s (Intel iMac with SSD)
Shell responsiveness is achieved using [Zinit](https://github.com/zdharma/zinit) turbo mode to load plugins and loading custom functions in fpath.

To view the fpath functions use ```fns --help```
To view the macOS functions use ```macfns --help```

The following prompt features can be enabled in the zshrc. To enable a feature set the variable to 'y' or as described.

| Option              | Description                                    |
| ------------------- | ---------------------------------------------- |
| PROMPT_CONTEXT      | User/host - y: User@Host u: User o: Other user |
| PROMPT_CLOCK        | Prompt clock - y: 24H clock 12: 12H clock      |
| PROMPT_HISTLINE     | Prompt history line number                     |
| PROMPT_PREFIX       | Prompt section prefixes                        |
| PROMPT_TRANSIENT    | Transient prompt - Trim previous prompt        |
| PROMPT_TRANSIENTOPT | Array of transient options: clock, histline    |
| PROMPT_DIRCOLOR     | Dir color - Use 'default' for stock color      |
| PROMPT_DIRTRIM      | Trim prompt dir path                           |
| PROMPT_DIRLOCK      | Prompt dir lock icon for unwriteable folders   |
| PROMPT_CHAR         | Prompt char (quote)                            |
| PROMPT_CHARCOL      | Prompt char color                              |
| PROMPT_EXPALIAS     | Expand aliases on prompt execution             |
| PROMPT_VENV         | Python virtualenv                              |
| PROMPT_DOCKER       | Docker module                                  |
| PROMPT_GIT          | Git module                                     |
| PROMPT_ICONS        | Prompt glyph icons                             |
| PROMPT_BOLD         | Prompt bold font                               |
| PROMPT_TITLES       | Prompt theme tab titles                        |
| PROMPT_CLOCKTICK    | Ticking clock                                  |
| PROMPT_HISTOFF      | Disable adding to history                      |
| PROMPT_HISTDISABLE  | Disable history                                |
| PROMPT_EXIT         | Prompt error color - resets after 3s           |
| PROMPT_MOTD         | Message of the day at login                    |
| PROMPT_RJOB         | Random job - rjob function from fpath          |
| RPROMPT_OFF         | Switch off right prompt                        |
| RPROMPT_CLOCK       | Right prompt clock                             |
| RPROMPT_CMDTIME     | Right prompt command time                      |
| RPROMPT_HISTLINE    | Right prompt history line number               |
| RPROMPT_MODULES     | Right prompt modules - git, docker             |
| RPROMPT_EXITCODE    | Right prompt exit code                         |
| RPROMPT_EXITSIG     | Right prompt exit signal                       |

### 🍺 Brew
My [Homebrew](https://github.com/Homebrew/brew) packages and casks.

### 🔨 Hammerspoon
My [Hammerspoon](https://github.com/Hammerspoon/hammerspoon) config, which includes app activation shortcuts, caffeinate, a fix for Karabiner breaking Mac eject key shortcuts on my keyboard and a sleepWatcher to run events after system wake.

### ⌨️ Karabiner
My [Karabiner](https://github.com/tekezo/Karabiner-Elements) config.

### 📃 Scripts
Some of my shell scripts including a Homebrew environment backup/restore and disk cloner.
