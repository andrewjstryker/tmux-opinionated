#! /usr/bin/env bash
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# opinionated.tmux
#
# Configure Tmux to have consistent, useful, and easy to remember bindings.
#
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmuxconf () {
  local conf

  conf=$(tmux show-option -gqv @tmuxconf)

  if [[ -n $conf ]]
  then
    echo "$conf"
    return
  fi

  conf="$XDG_CONFIG_HOME/tmux/tmux.conf"
  if [[ -w $XDG_CONFIG_HOME/tmux/tmux.conf ]]
  then
    echo "$conf"
    return
  fi

  echo "$HOME/.tmux.conf"
}

main () {
  tmuxconffile="$(tmuxconf)"
  tmux set-option -g "@tmuxconf" "$tmuxconffile"
  tmux source-file "${CURRENT_DIR}/opinionated.conf"
}

main
