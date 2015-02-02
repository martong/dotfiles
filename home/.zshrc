# FIX FOR OH MY ZSH GIT PROMPT SLOWNESS
# http://marc-abramowitz.com/archives/2012/04/10/fix-for-oh-my-zsh-git-svn-prompt-slowness/
function addGitSuperStatusHooks {
  add-zsh-hook chpwd chpwd_update_git_vars
  add-zsh-hook preexec preexec_update_git_vars
  add-zsh-hook precmd precmd_update_git_vars
}
function removeGitSuperStatusHooks {
  add-zsh-hook -d chpwd chpwd_update_git_vars
  add-zsh-hook -d preexec preexec_update_git_vars
  add-zsh-hook -d precmd precmd_update_git_vars
}
function git_prompt_info2() {
	if [ "$NO_GITSTATUS" = "absolutelyNothing" ]; then
		echo "no-git-status"
	elif [ -n "$NO_GITSTATUS" ]; then
		# From gitfast
		git_prompt_info
		#ref=$(git symbolic-ref HEAD 2> /dev/null) || return
		#echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
	else
		#git_prompt_info
		#echo -e "$(printBranch)"
		git_super_status
	fi
}
#NO_GITSTATUS="yes"

function rename_iterm2_tab() {
	WINDOW_NAME=$1
	export DISABLE_AUTO_TITLE="true"
	echo -ne "\e]1;$WINDOW_NAME\a"
}

function realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy-egbomrt"
#ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="yyyy-mm-dd"

autoload -U compinit
compinit

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)
#plugins=(git screen zsh-syntax-highlighting colorize per-directory-history)
# history-substring-search depends on the custom plugin zsh-syntax-highlighting,
# therefore it must be installed and loaded before history-substring-search.
plugins=(wd autojump brew vi-mode gitfast git-extras zsh-syntax-highlighting history-substring-search gradle)

source $ZSH/oh-my-zsh.sh

#  Completion from tmux pane
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  w=( ${(u)=$(tmux capture-pane \; show-buffer \; delete-buffer)} )
  _wanted values expl 'words from current tmux pane' compadd -a w
}
zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'


# 'ctrl-x r' will complete the N last modified (mtime) files/directories
zle -C newest-files complete-word _generic
zstyle ':completion:newest-files:*' completer _files
zstyle ':completion:newest-files:*' file-patterns '*~.*(omN[1,3])'
zstyle ':completion:newest-files:*' menu select yes
zstyle ':completion:newest-files:*' sort false
zstyle ':completion:newest-files:*' matcher-list 'b:=*' # important


function only-local-history-up () {
        zle set-local-history 1
        zle up-history
        zle set-local-history 0
}
function only-local-history-down () {
        zle set-local-history 1
        zle down-history
        zle set-local-history 0
}
zle -N only-local-history-up
zle -N only-local-history-down


# Custom widget to store a command line in history
# without executing it
commit-to-history() {
  print -s ${(z)BUFFER}
  zle send-break
}
zle -N commit-to-history


# Bindings
bindkey "^X^H" commit-to-history
bindkey "^Xh" push-line
bindkey -M viins "^X^H" commit-to-history
bindkey -M viins "^Xh" push-line

bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
bindkey -M viins '^Xt' tmux-pane-words-prefix
bindkey -M viins '^X^X' tmux-pane-words-anywhere

bindkey '^Xr' newest-files
bindkey -M viins '^X^r' newest-files

bindkey -M vicmd 'K' only-local-history-up
bindkey -M vicmd 'J' only-local-history-down

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -M vicmd '^r' redo
bindkey -M vicmd 'u' undo

bindkey -M vicmd 'g~' vi-oper-swap-case
# opp.zsh ~ is not vim-conform
bindkey -M vicmd '~' vi-swap-case

function vi-backward-word-end {
  vi-backward-word
  vi-backward-word
  vi-backward-char
  vi-forward-word-end
}
zle -N vi-backward-word-end
bindkey -M vicmd 'ge' vi-backward-word-end

function vi-backward-blank-word-end {
  vi-backward-blank-word
  vi-backward-blank-word
  vi-forward-blank-word-end
}
zle -N vi-backward-blank-word-end
bindkey -M vicmd 'gE' vi-backward-blank-word-end

# Enabling vim text-objects (ciw and alike) for vi-mode
#source ~/.opp.zsh/opp.zsh

HISTSIZE=30000
SAVEHIST=30000

source ~/.common_zsh_bash.rc
source ~/.last-command.zsh

# Simpulate the delete key I got used to
real-delete-char()
{
	zle vi-forward-char
	zle backward-delete-char
}
zle -N real-delete-char

# Bind generic keys properly for VI-MODE.
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# This is not working os OSX 10.9 and 10.10
#key[Up]=${terminfo[kcuu1]}
#key[Down]=${terminfo[kcud1]}
# vi cmd mode
[[ -n "${key[Home]}"     ]]  && bindkey -M vicmd  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey -M vicmd  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey -M vicmd  "${key[Insert]}"   vi-insert
[[ -n "${key[Delete]}"   ]]  && bindkey -M vicmd  "${key[Delete]}"   real-delete-char
#[[ -n "${key[PageUp]}"   ]]  && bindkey -M vicmd  "${key[PageUp]}"   only-local-history-up
#[[ -n "${key[PageDown]}" ]]  && bindkey -M vicmd  "${key[PageDown]}" only-local-history-down
# vi insert mode
[[ -n "${key[Home]}"     ]]  && bindkey -M viins  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey -M viins  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey -M viins  "${key[Insert]}"   vi-insert
[[ -n "${key[Delete]}"   ]]  && bindkey -M viins  "${key[Delete]}"   real-delete-char
#[[ -n "${key[Up]}"       ]]  && bindkey -M viins  "${key[Up]}"       history-substring-search-up
#[[ -n "${key[Down]}"     ]]  && bindkey -M viins  "${key[Down]}"     history-substring-search-down
[[ -n "${key[PageUp]}"   ]]  && bindkey -M viins  "${key[PageUp]}"   only-local-history-up
[[ -n "${key[PageDown]}" ]]  && bindkey -M viins  "${key[PageDown]}" only-local-history-down

# OSX specific
[[ -n "^[[A"     ]]  && bindkey -M viins  "^[[A"     history-substring-search-up
[[ -n "^[[B"     ]]  && bindkey -M viins  "^[[B"     history-substring-search-down

# After entering insert mode because of hitting a or A,
# I can't backspace past the point where I entered insert mode.
# So simulate vim instead of vi in case of insert mode
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^?" backward-delete-char      # Control-h also deletes the previous char
bindkey -M viins "^U" backward-kill-line

bindkey -M viins "^[a" accept-and-hold
# Shift-Tab
bindkey -M viins "^[[Z" reverse-menu-complete

nothing(){}
zle -N nothing

# By defult Esc is handled as a prefix, zsh waits a key after that,
# this results shit behaviour in vicmd mode.
bindkey -M vicmd "^[" nothing

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# even when the shell has exited background jobs will be left alone
setopt NO_HUP

