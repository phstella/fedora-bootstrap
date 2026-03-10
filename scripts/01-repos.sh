#!/usr/bin/env bash
set -euo pipefail

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }

# --- Terra repository (noctalia-shell) ---
if ! dnf repolist --enabled 2>/dev/null | grep -q terra; then
    info "Adding Terra repository (noctalia-shell)..."
    sudo dnf install -y --nogpgcheck \
        --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
        terra-release
else
    info "Terra repository already configured."
fi

# --- Hyprland COPR (hyprland, hyprpaper, hyprlock, cliphist, etc.) ---
if ! dnf repolist --enabled 2>/dev/null | grep -q "nett00n-hyprland"; then
    info "Adding nett00n/hyprland COPR..."
    sudo dnf copr enable -y nett00n/hyprland
else
    info "nett00n/hyprland COPR already configured."
fi

# --- Twingate ---
if ! command -v twingate &>/dev/null && ! dnf repolist --enabled 2>/dev/null | grep -q twingate; then
    info "Adding Twingate repository..."
    curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
else
    info "Twingate already configured."
fi

# --- Flathub (only for DBeaver) ---
if ! flatpak remotes --columns=name 2>/dev/null | grep -q flathub; then
    info "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
    info "Flathub already configured."
fi

info "Repositories configured."
