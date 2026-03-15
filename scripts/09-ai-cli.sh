#!/usr/bin/env bash
set -euo pipefail

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }

# --- Ensure Node/npm is available (installed in 02-packages.sh) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v npm &>/dev/null; then
    warn "npm not found — skipping AI CLI installs."
    exit 0
fi

# --- OpenAI Codex CLI ---
info "Installing OpenAI Codex CLI..."
if command -v codex &>/dev/null; then
    info "  codex already installed ($(codex --version 2>/dev/null || echo 'unknown'))."
else
    npm install -g @openai/codex
    info "  codex installed."
fi

# --- Anthropic Claude Code CLI ---
info "Installing Claude Code CLI..."
if command -v claude &>/dev/null; then
    info "  claude already installed ($(claude --version 2>/dev/null || echo 'unknown'))."
else
    curl -fsSL https://claude.ai/install.sh | bash
    info "  claude installed."
fi

info "AI CLI tools setup complete."
