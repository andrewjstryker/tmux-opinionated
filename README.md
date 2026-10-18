# Tmux-opinionated

Mnemonic window and session workflows layered on
[tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) and
[tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control).
Pain-control owns pane navigation, resizing, splitting, and window repositioning.
Opinionated adds lifecycle commands, copying, and monitoring while preserving
those bindings and your configured prefix. Requires tmux 3.0 or newer.

## Installation

With TPM, list sensible, pain-control, and opinionated in that order, then
initialize TPM. Replace `REPOSITORY_GIT_URL` below with the clone URL for this
repository; it is a placeholder, not a published GitHub slug.

```tmux
# Set your preferred prefix and opinionated options before loading plugins.
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-pain-control'
set -g @plugin 'REPOSITORY_GIT_URL'
run-shell '~/.tmux/plugins/tpm/tpm'
# Put personal binding overrides after this line.
```

Use TPM's prefix + I to install the plugins. TPM executes `opinionated.tmux`,
which loads `opinionated.conf`; do not load the config separately.

For manual installations, clone all three repositories and run their executable
entry points in order:

```tmux
run-shell '/path/to/tmux-sensible/sensible.tmux'
run-shell '/path/to/tmux-pain-control/pain_control.tmux'
run-shell '/path/to/tmux-opinionated/opinionated.tmux'
```

Dependencies are installed separately.

## Bindings

All keys below follow your tmux prefix. Paired lifecycle commands use lowercase
for windows and uppercase for sessions (`n/N`, `r/R`); this is not a rule for
all uppercase keys.

| Keys | Action |
| --- | --- |
| `n` / `N` | Create and name a window / session |
| `r` / `R` | Rename a window / session |
| `[` | Enter copy mode |
| `p` / `C-p` | Paste / choose a buffer |
| `g` | Gather: link a window from another session |
| `x` | Kill the current pane, with confirmation |
| `X` | Open a kill menu: `x` pane, `w` window, `a` other windows, `s` session, `S` server; Escape dismisses |
| `D` | Detach |
| `S` | Toggle the status line |
| `M` | Merge windows into another session |
| `m` | Toggle activity monitoring for the current window |
| `v` | Silence monitoring menu: set an interval or disable |
| `Tab` / `C-Tab` | Last pane / window (Ctrl-Tab requires terminal support) |
| `M-Left` / `M-Right` | Previous / next window (Alt-Left / Alt-Right) |
| Ctrl + arrow | Resize the pane in that direction |

Activity and silence monitoring are independent. `m` toggles activity only;
`M` retains session merging. `v` configures the silence timeout, with zero
disabling it.

Every kill-menu action asks for confirmation. `h/j/k/l`, their Control variants,
`H/J/K/L`, and the split and window repositioning keys remain pain-control's.
Default aliases such as `]` for paste and `z` for zoom are retained.
Copy-mode scrolling additions currently apply to vi copy mode only.

By default, `c` retains pain-control's new-window behavior. To make it an alias
for copy mode, set this option before loading opinionated:

```tmux
set -g @opinionated-copy-on-c on
```

`[` always enters copy mode. Set the option to `off` (or unset it) and reload
to restore `c` to creating a window in the current directory. `n` always creates
a window. Opinionated deliberately replaces sensible's `R` reload and `C-p`
previous-window shortcuts with rename-session and choose-buffer.

When upgrading from an earlier opinionated config, reload the full configuration
including pain-control to restore its bindings. A fresh server also clears
removed bindings. On an existing server upgraded from the previous version,
run these once to remove the obsolete window-navigation and monitoring aliases
(unless you have since customized them):

```tmux
unbind-key C-[
unbind-key C-]
unbind-key C-m
```

## Credits

The tmux plugin authors, particularly tmux-sensible and tmux-pain-control.
The original configuration also contains borrowed snippets whose attribution
remains to be identified.
