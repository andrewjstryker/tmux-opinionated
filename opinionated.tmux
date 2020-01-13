# Opinioated
#
# A collection of tmux bindinss packaged for the tmux plugin manager.
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

unbind () {
  # remove the following default bindings
  tmux unbind-key '$'       # rename-session
  tmux unbind-key ','       # rename-window
  tmux unbind-key '%'       # split-window -h
  tmux unbind-key '"'       # split-window
  tmux unbind-key '{'       # swap-pane -U
  tmux unbind-key '}'       # swap-pane -D
  tmux unbind-key '['       # copy-mode
  tmux unbind-key ']'       # paste-buffer
  tmux unbind-key "'"       # select-window
  tmux unbind-key 'n'       # next-window
  tmux unbind-key 'p'       # previous-window
  tmux unbind-key 'l'       # last-window
  tmux unbind-key 'M-n'     # next window with alert
  tmux unbind-key 'M-p'     # next window with alert
  tmux unbind-key 'o'       # focus thru panes
  tmux unbind-key '&'       # kill-window
  tmux unbind-key '#'       # list-buffer
  tmux unbind-key '='       # choose-buffer
  tmux unbind-key 'z'       # zoom-pane
  tmux unbind-key 'M-Up'    # resize 5 rows up
  tmux unbind-key 'M-Down'  # resize 5 rows down
  tmux unbind-key 'M-Right' # resize 5 rows right
  tmux unbind-key 'M-Left'  # resize 5 rows left
}

sessions () {
  tmux bind-key C new-session -c "#{pane_current_path} ; command-prompt -I \"#{window_name}\" \"rename-window '%%'\""
  tmux bind-key R command-prompt -I "#{session_name}" "rename-session '%%'"
  tmux bind-key d detach-client
  tmux bind-key L command-prompt -p "Link window from (session:window): " "link-window -s %% -a"

  # Merge session with another one (e.g. move all windows)
  # If you use adhoc 1-window sessions, and you want to preserve session upon exit
  # but don't want to create a lot of small unnamed 1-window sessions around
  # move all windows from current session to main named one (dev, work, etc)
  tmux bind-key C-u command-prompt -p "Session to merge with: " \
    "run-shell 'yes | head -n #{session_windows} | xargs -I {} -n 1 tmux movew -t %%'"
  tmux bind-key Q confirm-before -p "kill-session #S? (y/n)" kill-session

  tmux bind-key D if -F '#{session_many_attached}' \
      'confirm-before -p "Detach other clients? (y/n)" "detach-client -a"' \
      'display "Session has only 1 client attached"'
}

windows () {
  tmux bind-key c new-window -c '#{pane_current_path}'
  # TODO: ask for a window name
  # tmux bind-key c new-window -c "'#{pane_current_path}' ; command-prompt -I '#{window_name}' 'rename-window %%'"
  tmux bind-key r command-prompt -I "#{window_name}" "rename-window '%%'"
  tmux bind-key -r C-Tab last-window
  tmux bind-key -r Tab last-pane
  tmux bind-key -r C-Left previous-window
  tmux bind-key -r C-Right next-window
  tmux bind-key -r "C-[" previous-window
  tmux bind-key -r "C-]" next-window
  tmux bind-key C-X confirm-before -p "kill other windows? (y/n)" "kill-window -a"
  tmux bind-key X kill-window
}

panes () {
  tmux bind-key "|" split-window -h -c "#{pane_current_path}"
  tmux bind-key "_" split-window -v -c "#{pane_current_path}"
  tmux bind-key -r "Left" select-pane -t :.-
  tmux bind-key -r "Right" select-pane -t :.+
  tmux bind-key -r "[" select-pane -t :.-
  tmux bind-key -r "]" select-pane -t :.+
  tmux bind-key x kill-pane
  tmux bind-key -r "C-o" swap-pane -D
  # Swap panes back and forth with 1st pane
  # When in main-(horizontal|vertical) layouts, the biggest/widest panel is always @1
  tmux bind-key "\\" if '[ #{pane_index} -eq 1 ]' \
      'swap-pane -s "!"' \
      'select-pane -t:.1 ; swap-pane -d -t 1 -s "!"'
}

monitoring () {
  tmux bind-key m "setw monitor-activity ; display-message 'Monitor window activity [#{?monitor-activity,ON,OFF}]'"
  tmux bind-key M "if -F '#{monitor-silence}' 'setw monitor-silence 0 ; display-message \"Monitor window silence [OFF]\"' 'command-prompt -p \"Monitor silence: interval (s)\" \"setw monitor-silence %%\"'"
}

copying () {
  # Pasting
  tmux bind-key p paste-buffer
  tmux bind-key C-p choose-buffer

  # Copying
  tmux bind-key "-n" M-Up copy-mode

  # Scroll up/down by 1 line, half screen, whole screen
  tmux bind-key "-T" copy-mode-vi M-Up              send-keys -X scroll-up
  tmux bind-key "-T" copy-mode-vi M-Down            send-keys -X scroll-down
  tmux bind-key "-T" copy-mode-vi M-PageUp          send-keys -X halfpage-up
  tmux bind-key "-T" copy-mode-vi M-PageDown        send-keys -X halfpage-down
  tmux bind-key "-T" copy-mode-vi PageDown          send-keys -X page-down
  tmux bind-key "-T" copy-mode-vi PageUp            send-keys -X page-up

  # When scrolling with mouse wheel, reduce number of scrolled rows per tick to "2" (default is 5)
  # TODO: resolve 'not in a mode'
  #tmux bind-key "-T" copy-mode-vi WheelUpPane       select-pane \; send-keys -X -N 2 scroll-up
  #tmux bind-key "-T" copy-mode-vi WheelDownPane     select-pane \; send-keys -X -N 2 scroll-down
}

zooming () {
  tmux bind-key + resize-pane -Z
}

configuring () {
  tmux bind-key C-e new-window -n 'tmux.conf' "sh -c '\${EDITOR:-vim} $(tmuxconf) && tmux source $(tmuxconf) && tmux display \"Config reloaded\"'"
  tmux bind-key C-r "source-file $(tmuxconf) ; display 'Config reloaded'"
}

main () {
  tmux set-option -g prefix C-a

  sessions
  windows
  panes

  copying
  monitoring
  zooming
  configuring

  # Toggling status bar
  tmux bind-key "C-s" if -F '#{s/off//:status}' 'set status off' 'set status on'
}

main
