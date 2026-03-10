# Fedora Bootstrap

Fedora desktop setup — Hyprland + noctalia-shell + Gruvbox theming. Migrated from [arch-dotfiles](https://github.com/phstella/arch-dotfiles) and adapted for Fedora with native packages wherever possible. Managed with a phased bootstrap script that pulls dotfiles via GNU Stow.

## What's Included

- **Window Manager**: Hyprland (dwindle layout) via COPR
- **Shell/Bar**: noctalia-shell via Terra repository
- **Terminal**: Kitty with JetBrainsMono Nerd Font
- **Shell**: zsh + Oh My Zsh (robbyrussell theme)
- **Theming**: Gruvbox (dark), Breeze Dark for Qt/KDE, Adwaita-dark for GTK
- **Browser**: Firefox with Betterfox hardening
- **Apps**: DBeaver (Flatpak), Slack (native RPM), Spotify (lpf), Twingate
- **~60 DNF packages, 1 Flatpak, 3 external repos**

## Prerequisites

A fresh Fedora install (43+) with:
- Working network connection
- `git` and `gh` installed and authenticated
- SSH keys in `~/.ssh/` for GitHub access

## Install

```bash
git clone git@github.com:phstella/fedora-bootstrap.git ~/fedora-bootstrap
cd ~/fedora-bootstrap && ./install.sh
```

## Bootstrap Phases

| Phase | Script | Description |
|-------|--------|-------------|
| 1 | `01-repos.sh` | Add Terra, COPR nett00n/hyprland, Twingate, Flathub repos |
| 2 | `02-packages.sh` | Install DNF packages, Slack RPM, Spotify via lpf, Twingate, uv, Flatpak apps |
| 3 | `03-services.sh` | Enable systemd services (sddm, NetworkManager, bluetooth, pipewire) |
| 4 | `04-fonts.sh` | Download and install JetBrainsMono Nerd Font |
| 5 | `05-shell.sh` | Set zsh as default, install Oh My Zsh, stow .zshrc, fix plugin paths |
| 6 | `06-stow.sh` | Clone arch-dotfiles, symlink via GNU Stow, apply Fedora patches |
| 7 | `07-post.sh` | Firefox user.js, GTK dark mode, KDE cache rebuild, create directories |

All phases are idempotent and safe to re-run.

## Fedora-Specific Adaptations

Changes applied automatically over the Arch dotfiles:

- **noctalia-shell** installed from Terra instead of AUR
- **Hyprland ecosystem** (hyprland, hyprpaper, cliphist, hyprlock) from COPR nett00n/hyprland
- **zsh plugin paths** patched (`/usr/share/zsh-autosuggestions/` vs Arch's `/usr/share/zsh/plugins/`)
- **`XDG_MENU_PREFIX=arch-`** commented out in hyprland.conf
- **`code-oss.desktop`** replaced with `org.kde.kate.desktop` in MIME associations
- **GTK font/DPI** added (Noto Sans 10, 96 DPI) since Arch config omitted them
- **Qt6ct font** normalized from size 12 to 10
- **`power-profiles-daemon`** skipped (Fedora ships `tuned-ppd`)
- **`gstreamer1-plugin-pipewire`** mapped to `pipewire-gstreamer`

## Manual Steps After Install

- Run `lpf update spotify-client` to build the Spotify native RPM
- Run `sudo twingate setup` to configure Twingate
- Reboot and select **Hyprland** from the SDDM session dropdown
- Log into Firefox and install extensions
- Add wallpapers to `~/Pictures/Wallpapers/`
- Configure SDDM theme if desired (`/etc/sddm.conf.d/`)
