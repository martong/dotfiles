# Source Prezto.
 if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
 fi


function realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}


source ~/.last-command.zsh


# N last modified (mtime) files/directories
zle -C newest-files complete-word _generic
zstyle ':completion:newest-files:*' completer _files
zstyle ':completion:newest-files:*' file-patterns '*(omN[1,3])'
zstyle ':completion:newest-files:*' menu select yes
zstyle ':completion:newest-files:*' sort false
zstyle ':completion:newest-files:*' matcher-list 'b:=*' # important

bindkey '^Xr' newest-files
bindkey -M viins '^X^r' newest-files


# Local and global history
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

bindkey -M vicmd 'K' only-local-history-up
bindkey -M vicmd 'J' only-local-history-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


# VIM compatibility
bindkey -M vicmd '^r' redo
bindkey -M vicmd 'u' undo

bindkey -M vicmd 'g~' vi-oper-swap-case
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
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done
autoload -Uz surround
zle -N delete-surround surround
zle -N change-surround surround
zle -N add-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

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


# History specific settings
HIST_STAMPS="yyyy-mm-dd"
COMPLETION_WAITING_DOTS="true"
setopt histfindnodups
HISTSIZE=30000
HISTFILE=$HOME/.zsh_history
SAVEHIST=30000
alias history='fc -il 1'
alias h='fc -il 1'


# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# even when the shell has exited background jobs will be left alone
setopt NO_HUP

# Non-alphanumeric chars treated as part of a word except '/'
# So C-W behaves like in bash.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Do not require >! to redirect stdout into existing file
setopt clobber


source ~/.common_zsh_bash.rc
# Add aliases, overwrite some prezto aliases
test -s ~/.alias && . ~/.alias || true
