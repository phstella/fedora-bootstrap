#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DOTFILES_DIR="$HOME/arch-dotfiles"

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }

# Ensure dotfiles are cloned before we need the .zshrc
if [[ ! -d "$DOTFILES_DIR" ]]; then
    info "Cloning dotfiles repo..."
    git clone git@github.com:phstella/arch-dotfiles.git "$DOTFILES_DIR"
fi

current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$current_shell" != */zsh ]]; then
    info "Setting zsh as default shell..."
    chsh -s "$(command -v zsh)"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing Oh My Zsh (unattended)..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Stow .zshrc from dotfiles after oh-my-zsh so it doesn't get overwritten
if [[ -d "$DOTFILES_DIR" ]]; then
    info "Stowing zsh config..."
    cd "$DOTFILES_DIR"
    if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.omz-default"
        info "  Backed up oh-my-zsh default .zshrc -> .zshrc.omz-default"
    fi
    stow -v -t "$HOME" zsh
else
    warn "Dotfiles repo not found at $DOTFILES_DIR — skipping .zshrc stow."
    warn "Clone it first: git clone git@github.com:phstella/arch-dotfiles.git ~/arch-dotfiles"
fi

# Fix zsh plugin paths for Fedora (Arch uses /usr/share/zsh/plugins/<name>/)
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]]; then
    info "Patching zsh plugin paths for Fedora..."

    ARCH_AUTOSUGGESTIONS="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    FEDORA_AUTOSUGGESTIONS="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

    ARCH_SYNTAX="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    FEDORA_SYNTAX="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    if grep -qF "$ARCH_AUTOSUGGESTIONS" "$ZSHRC"; then
        sed -i "s|$ARCH_AUTOSUGGESTIONS|$FEDORA_AUTOSUGGESTIONS|g" "$ZSHRC"
        info "  Fixed zsh-autosuggestions path."
    fi

    if grep -qF "$ARCH_SYNTAX" "$ZSHRC"; then
        sed -i "s|$ARCH_SYNTAX|$FEDORA_SYNTAX|g" "$ZSHRC"
        info "  Fixed zsh-syntax-highlighting path."
    fi
fi

info "Shell setup complete."
