# Running Windows Apps with Wine

## Run an `.exe` directly

```bash
wine /path/to/your/app.exe
```

The first time you run Wine, it will automatically create a **wineprefix** at `~/.wine` — this is a virtual C: drive with a minimal Windows directory structure.

## Install a Windows app (e.g. from a setup wizard)

```bash
wine /path/to/Setup.exe
```

Follow the installer as you would on Windows. The app gets installed inside `~/.wine/drive_c/`.

## Run the installed app afterward

```bash
wine ~/.wine/drive_c/Program\ Files/AppName/app.exe
```

## Useful commands

| Command | What it does |
|---|---|
| `wine --version` | Check installed Wine version |
| `winecfg` | Open Wine's graphical settings (Windows version, DPI, drives) |
| `winetricks` | Install common Windows libraries (e.g. .NET, Visual C++ runtimes) — install with `sudo dnf install winetricks` |
| `wine uninstaller` | Open the Wine "Add/Remove Programs" panel |

## Separate prefixes for different apps

If two apps conflict, give each its own isolated prefix:

```bash
WINEPREFIX=~/wine-app1 wine /path/to/app1.exe
WINEPREFIX=~/wine-app2 wine /path/to/app2.exe
```

## Tips

- Fedora 43's Wine uses **WoW64 mode** — it runs 32-bit Windows apps inside a 64-bit Wine process, so no separate 32-bit libraries are needed.
- For games, **Steam's Proton** (built into the Steam client) is usually better than raw Wine. Just enable "Steam Play" in Steam settings.
- For stubborn apps that need extra DLLs, install `winetricks` and run `winetricks vcrun2022 dotnet48` (or whatever the app needs).
