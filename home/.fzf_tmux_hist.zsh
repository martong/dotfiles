__fseltmuxhist() {
  local cmd='tmux capture-pane -pt "$target-pane" | tr " " "\n"'
  setopt localoptions pipefail 2> /dev/null
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) --tac -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

fzf-tmux-hist-widget() {
  LBUFFER="${LBUFFER}$(__fseltmuxhist)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-tmux-hist-widget
bindkey '^F' fzf-tmux-hist-widget
