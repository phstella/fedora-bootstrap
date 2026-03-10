#!/usr/bin/env bash
set -euo pipefail

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }

SYSTEM_SERVICES=(
    sddm.service
    NetworkManager.service
    bluetooth.service
    fstrim.timer
    systemd-timesyncd.service
)

USER_SERVICES=(
    pipewire.socket
    pipewire-pulse.socket
    wireplumber.service
    ssh-agent.socket
)

info "Enabling system services..."
for svc in "${SYSTEM_SERVICES[@]}"; do
    sudo systemctl enable --now "$svc" 2>/dev/null || \
        sudo systemctl enable "$svc" 2>/dev/null || true
    info "  $svc"
done

info "Enabling user services..."
for svc in "${USER_SERVICES[@]}"; do
    systemctl --user enable --now "$svc" 2>/dev/null || \
        systemctl --user enable "$svc" 2>/dev/null || true
    info "  $svc"
done

info "Services configured."
