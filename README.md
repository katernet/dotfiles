# dotfiles

My dotfiles

Feel free to use and adapt as needed.

<p align="center">
  <img src="https://images2.imgbox.com/08/54/uf3EEmiz_o.png"/>
</p>

### 🖥 zsh

A custom zsh config, including a personalised theme with plugin support and an async git status.

The shell loads in 29 ms (Intel iMac with SSD).  
Benchmark results measured using [zsh-bench](https://github.com/romkatv/zsh-bench)

Shell responsiveness is achieved by deferring plugins and lazy loading functions via fpath.  
The plugin code is adapted from [zsh_unplugged](https://github.com/mattmc3/zsh_unplugged)

Included plugins:  
zsh-defer  
ohmyzsh git  
zsh-thefuck  
zsh-notify  
fast-syntax-highlighting  
zsh-autosuggestions

The following prompt features can be enabled in the zshrc. To enable a feature set the variable to 'y' or as described.

| Option              | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| PROMPT_CONTEXT      | y: User@Host u: User o: Other user r: Remote context         |
| PROMPT_CLOCK        | Prompt clock - y: 24H clock 12: 12H clock                    |
| PROMPT_HISTLINE     | Prompt history line number                                   |
| PROMPT_BOLD	        | Bold prompt				                                           |
| PROMPT_PREFIX       | Prompt section prefixes                                      |
| PROMPT_ICONS        | Prompt glyph icons 			                                     |
| PROMPT_OS	          | Show OS icon - Arch, BSD, Linux, macOS	                     |
| PROMPT_NEWLINE      | Show a new line after the prompt	                           |
| PROMPT_TRANSIENT    | Transient prompt - Trim previous prompts                     |
| PROMPT_TRANSIENTOPT | Opts: newline, clock, hist                                   |
| PROMPT_DIR          | Dir opts - trim: Trim pwd path c: Current dir y: Full path   |
| PROMPT_DIRRESUME    | Resume last dir from dirstack at login                       |
| PROMPT_DIRLOCK      | Prompt dir lock icon for unwriteable folders                 |
| PROMPT_DIRCOLOR     | Dir color - Use 'default' for stock color                    |
| PROMPT_CHAR         | Custom prompt character                                      |
| PROMPT_CHARCOL      | Custom prompt character color                                |
| PROMPT_DOCKER       | Docker module                                                |
| PROMPT_GITVCS       | Git vcs async module                                         |
| PROMPT_VENV         | Python virtualenv                                            |
| PROMPT_TITLES       | Prompt theme tab titles                                      |
| PROMPT_CLOCKTICK    | Ticking clock (minor bugs)                                   |
| PROMPT_CLOCKEXE     | Refresh clock after command (use without ticking clock)      |
| PROMPT_EXIT         | Prompt error color                                           |
| PROMPT_EXITRESET    | Async timer to reset prompt error color after 5s             |
| PROMPT_MOTD         | Message of the day at login                                  |
| PROMPT_MOTDOPT      | Opts: help, (neo/fast)fetch, hostinfo, greeting, quote, todo |
| PROMPT_BOTTOM       | Set the prompt at the bottom of the Terminal                 |
| PROMPT_COMPILE      | Compile zsh config files and compdump for fast load          |
| PROMPT_ZHELP=xman   | Use Apple x-man-page - macOS only	                           |
| RPROMPT_OFF         | Switch off right prompt                                      |
| RPROMPT_CLOCK       | Right prompt clock                                           |
| RPROMPT_CMDTIME     | Right prompt command time                                    |
| RPROMPT_HISTLINE    | Right prompt history line number                             |
| RPROMPT_DOCKER      | Right prompt docker module	                                 |
| RPROMPT_GITVCS      | Right prompt git vcs module	                                 |
| RPROMPT_JOBS        | Right prompt background job status                           |
| RPROMPT_EXITCODE    | Right prompt exit code                                       |
| RPROMPT_EXITSIG     | Right prompt exit signal                                     |

### 🍺 Brew
My [Homebrew](https://github.com/Homebrew/brew) packages and casks.

### 🔨 Hammerspoon
My [Hammerspoon](https://github.com/Hammerspoon/hammerspoon) config, which includes app activation shortcuts, caffeinate and SpoonInstall.

### ⌨️ Karabiner
My [Karabiner](https://github.com/tekezo/Karabiner-Elements) config.

### 📃 Scripts
Some of my shell scripts including a Homebrew environment backup/restore and disk cloner.
