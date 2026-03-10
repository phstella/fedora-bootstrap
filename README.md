# Fedora Bootstrap

Fedora desktop setup — Hyprland + noctalia-shell + Gruvbox theming. Self-contained repo with all dotfiles and a phased bootstrap script. One command to go from a stock Fedora KDE install to a fully configured Hyprland tiling desktop.

## What's Included

- **Window Manager**: Hyprland (dwindle layout) via COPR
- **Shell/Bar**: noctalia-shell via Terra repository
- **Terminal**: Kitty with JetBrainsMono Nerd Font
- **Shell**: zsh + Oh My Zsh (robbyrussell theme)
- **Theming**: Gruvbox (dark), Breeze Dark for Qt/KDE, Adwaita-dark for GTK
- **Browser**: Firefox with Betterfox hardening
- **Apps**: DBeaver (Flatpak), Slack (native RPM), Spotify (native via lpf), Twingate
- **Dotfiles**: Managed with GNU Stow, all configs included in this repo

## Prerequisites

A fresh Fedora install (43+) with:
- Working network connection
- `git` installed

## Install

```bash
git clone https://github.com/phstella/fedora-bootstrap.git ~/fedora-bootstrap
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
| 6 | `06-stow.sh` | Symlink dotfiles via GNU Stow, apply Fedora-specific patches |
| 7 | `07-post.sh` | Firefox user.js, GTK dark mode, KDE cache rebuild, create directories |

All phases are idempotent and safe to re-run.

## Stow Packages

Each top-level directory is a GNU Stow package that symlinks into `$HOME`:

| Package | Files |
|---------|-------|
| `hypr` | `~/.config/hypr/hyprland.conf` |
| `noctalia` | `~/.config/noctalia/{settings,colors}.json` |
| `kitty` | `~/.config/kitty/{kitty.conf,current-theme.conf}` |
| `zsh` | `~/.zshrc` |
| `gtk` | `~/.config/gtk-{3.0,4.0}/settings.ini` |
| `qt` | `~/.config/qt6ct/{qt6ct.conf,colors/noctalia.conf}` |
| `kde` | `~/.config/kdeglobals` |
| `mime` | `~/.config/mimeapps.list` |
| `gh` | `~/.config/gh/config.yml` |
| `firefox` | Copied into profile by script (not stowed) |

## Patches Applied Automatically

The bootstrap detects Fedora and fixes these differences from Arch:

- zsh plugin paths (`/usr/share/zsh-autosuggestions/` vs Arch's `/usr/share/zsh/plugins/`)
- `XDG_MENU_PREFIX=arch-` commented out in hyprland.conf
- `code-oss.desktop` replaced with `org.kde.kate.desktop` in MIME associations
- GTK font/DPI added (Noto Sans 10, 96 DPI)
- Qt6ct font normalized from size 12 to 10
- Hardcoded home paths replaced with `$HOME`
- `power-profiles-daemon` skipped (Fedora ships `tuned-ppd`)
- `gstreamer1-plugin-pipewire` mapped to `pipewire-gstreamer`

## Manual Steps After Install

- Run `lpf update spotify-client` to build the Spotify native RPM
- Run `sudo twingate setup` to configure Twingate
- Reboot and select **Hyprland** from the SDDM session dropdown
- Log into Firefox and install extensions
- Add wallpapers to `~/Pictures/Wallpapers/`
- Set up your SSH keys in `~/.ssh/`

## Customizing

To add your own configs, create a new stow package:

```bash
mkdir -p newpkg/.config/app/
# move config files into it
stow -v -t ~ newpkg
```

Then commit and push.
