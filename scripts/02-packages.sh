#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }

info "Installing DNF packages..."
sudo dnf install -y $(cat "$REPO_DIR/packages/dnf.txt" | grep -v '^#' | grep -v '^$')

info "Installing Slack (native RPM)..."
if ! rpm -q slack &>/dev/null; then
    slack_rpm="$(mktemp /tmp/slack-XXXXXX.rpm)"
    slack_url="$(curl -sI 'https://slack.com/downloads/instructions/linux?ddl=1&build=rpm' \
        | grep -oP 'https://downloads\.slack-edge\.com\S+\.rpm' || true)"
    if [[ -z "$slack_url" ]]; then
        slack_url="https://downloads.slack-edge.com/desktop-releases/linux/x64/4.47.69/slack-4.47.69-0.1.el8.x86_64.rpm"
    fi
    curl -fLo "$slack_rpm" "$slack_url"
    sudo dnf install -y "$slack_rpm"
    rm -f "$slack_rpm"
else
    info "Slack already installed."
fi

info "Installing Spotify (native RPM via lpf)..."
if command -v lpf &>/dev/null; then
    lpf update spotify-client 2>/dev/null || warn "Run 'lpf update spotify-client' manually after reboot."
else
    warn "lpf not yet available — run 'lpf update spotify-client' after reboot to build the Spotify RPM."
fi

info "Installing Twingate..."
sudo dnf install -y twingate || warn "Twingate install failed — check repo setup."

info "Installing uv (Python package manager)..."
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    info "uv already installed."
fi

info "Installing nvm and Node.js v24..."
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if ! nvm ls 24 &>/dev/null; then
    nvm install 24
    nvm alias default 24
else
    info "Node v24 already installed."
fi

info "Installing Flatpak apps..."
while IFS= read -r app; do
    [[ -z "$app" || "$app" == \#* ]] && continue
    if ! flatpak list --app --columns=application 2>/dev/null | grep -q "$app"; then
        info "  Installing $app..."
        flatpak install -y flathub "$app"
    else
        info "  $app already installed."
    fi
done < "$REPO_DIR/packages/flatpak.txt"

info "Packages installed."
