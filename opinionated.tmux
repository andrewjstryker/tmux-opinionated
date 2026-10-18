#!/usr/bin/env bash
# TPM executes this launcher; tmux reads the bindings as native configuration.

CURRENT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1
exec tmux source-file "${CURRENT_DIR}/opinionated.conf"
