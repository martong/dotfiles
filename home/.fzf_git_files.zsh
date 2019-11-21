# fgst - pick files from `git status -s`
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

__fgst() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read -r item; do
    echo "$item" | awk '{print $2}'
  done
  echo
}

fzf-git-files-widget() {
  LBUFFER="${LBUFFER}$(__fgst)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-git-files-widget
bindkey '^G' fzf-git-files-widget
