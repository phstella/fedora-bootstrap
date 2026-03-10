#!/usr/bin/env bash
set -euo pipefail

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }

FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"

if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    info "JetBrainsMono Nerd Font already installed."
else
    info "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$FONT_DIR"
    tmpzip="$(mktemp /tmp/jbmono-nerd-XXXXXX.zip)"
    curl -fLo "$tmpzip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o "$tmpzip" -d "$FONT_DIR"
    rm -f "$tmpzip"
    fc-cache -fv
    info "JetBrainsMono Nerd Font installed."
fi
