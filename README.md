# Dotfiles Backup

Hyprland + Quickshell rice, originally based on [ilyamiro/nixos-configuration](https://github.com/ilyamiro/nixos-configuration) — now spun off into own setup (Lua migration, per-host overlays). Lockscreen is stripped Quickshell `Lock.qml` (qylock/pixel themes removed).

## Backed Up Configs

| Path | Description |
|---|---|
| `.config/hypr/` | Hyprland compositor — modular config structure (`config/` subdirectory), Quickshell UI panels, custom scripts, matugen colors, hypridle |
| `.config/hypr/scripts/quickshell/` | Quickshell UI — app launcher, top bar, notifications, music player, volume, network, battery, calendar, clipboard, screenshot, wallpaper picker, focustime, monitors, settings, guide |
| `.config/kitty/` | Kitty terminal — `kitty.conf` font/size/cursor, `colors.conf` + `kitty-matugen-colors.conf` |
| `.local/share/quickshell-lockscreen/` | Legacy qylock (kept for reference, no longer used — see `lock_simple/`) |
| `.config/waybar/` | Waybar config, styles, scripts (installed but not in autostart — replaced by Quickshell TopBar) |
| `.config/rofi/` | Rofi theme (installed but secondary to Quickshell app launcher) |
| `.config/dunst/` | Dunst notification daemon (installed but not in autostart — replaced by Quickshell notifications) |
| `.config/swaync/` | SwayNC notification center (installed but not in autostart — replaced by Quickshell notifications) |
| `.config/wlogout/` | Wlogout logout menu (installed but not in autostart) |
| `.config/swaylock/` | Swaylock (installed but replaced by qylock Quickshell lockscreen) |
| `.config/swayosd/` | SwayOSD on-screen display for volume/brightness/caps lock |
| `.config/qylock/` | qylock theme selection (`pixel-night-city`) |
| `.config/gtk-3.0/` | GTK3 theme settings |
| `.config/gtk-4.0/` | GTK4 theme settings |
| `.config/Kvantum/` | Kvantum theme selector (`catppuccin-mocha-peach`) |
| `.config/nwg-look/` | nwg-look GTK theme settings |
| `.config/qt6ct/` | Qt6 appearance — matugen-generated colors and stylesheets |

## Structure

- `hosts/desktop|tv|laptop/settings.json` — Per-host overlays (monitors, idle, scale). `desktop` is dual DP-3/HDMI (1-5 DP-3, 6-10 HDMI), `laptop` ThinkPad T14 eDP-1, `tv` HDMI single with idle off.
- `tools/json2lua.py` — Idempotent own JSON→Lua generator (`settings.json` → `config/*.lua` + `hyprland.lua` via `hl.*`). Keeps `settings_watcher.sh`.
- `install/arch-full-install.sh` — Mode A: clean Arch archiso 0→Hyprland (laptop/tv, with `yay` deps + auto `hyprctl monitors -j` detect).
- `install/cachyos-overlay.sh` — Mode B: CachyOS overlay only (desktop, deps + rsync, no repartition).
- `secrets/.env.example` — Never commit `secrets/.env`.

## Scripts

- **`backup.sh`** — Sync dotfiles into repo (`backup.sh [--host desktop|laptop|tv]`, now includes `kitty`).
- **`push.sh`** — Commit and push (`push.sh "msg"`). One-click: `backup.sh && push.sh`.
- **`tools/json2lua.py [host]`** — Regenerate Lua (idempotent, atomic `.tmp`→`.lua`).

## Not Backed Up (System-Level)

These live outside user config and require manual setup:

### SDDM / Lock

- Legacy `qylock` + `pixel-night-city`/`pixel-skyscrapers` removed (resource heavy, dual-lock crash via `hypridle` 600s → `loginctl lock-session` + `Lock.qml`). Branch `legacy-conf` + tag `pre-lua-20260901` + `~/hypr_conf_legacy_20260901.tgz` preserve old.
- Now: single stripped `quickshell/Lock.qml` (`hypridle.conf: lock_cmd = bash ~/.config/hypr/scripts/lock.sh`), SDDM at `/etc/sddm.conf.d/` uses simple theme.
- `hypridle` per-host: desktop 600s, laptop dim 120s/dpms 300s, tv idle off.

## Active Themes / Dependencies

### In Use
| Component | Value | Source |
|---|---|---|
| GTK theme | `adw-gtk3-dark` | Standard Arch package (`extra/adw-gtk3`) |
| Icon theme | `Tela-dark` | [github.com/vinceliuice/Tela-icon-theme](https://github.com/vinceliuice/Tela-icon-theme) |
| Kvantum theme | `catppuccin-mocha-peach` | [github.com/catppuccin/Kvantum](https://github.com/catppuccin/Kvantum) |
| Color scheme | Matugen-generated | [github.com/InioX/matugen](https://github.com/InioX/matugen) — generates colors from wallpaper |
| Font | JetBrains Mono | Standard Arch package (`extra/ttf-jetbrains-mono`) |
| Lockscreen | Stripped `quickshell/Lock.qml` | Own |
| SDDM theme | Simple (qylock removed) | — |

### Also Installed (from previous rice)
| Theme | Source |
|---|---|
| Catppuccin Mocha GTK | [github.com/catppuccin/gtk](https://github.com/catppuccin/gtk) |
| WhiteSur / WhiteSur-dark GTK | [github.com/vinceliuice/WhiteSur-gtk-theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) |
| Sweet / Sweet-Dark / Sweet-ambar-blue GTK | [github.com/EliverLara/Sweet](https://github.com/EliverLara/Sweet) |
| Layan GTK | [github.com/vinceliuice/Layan-gtk-theme](https://github.com/vinceliuice/Layan-gtk-theme) |
| Nordic GTK | [github.com/EliverLara/Nordic](https://github.com/EliverLara/Nordic) |
| candy-icons | [github.com/EliverLara/candy-icons](https://github.com/EliverLara/candy-icons) |
| WhiteSur / WhiteSur-dark / WhiteSur-light icons | [github.com/vinceliuice/WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme) |
| McMojave-circle / -dark / -light icons | [github.com/vinceliuice/McMojave-circle](https://github.com/vinceliuice/McMojave-circle) |
| Nordic-bluish / Nordic-darker / Nordic-green icons | [github.com/vinceliuice/Nordzy-icon](https://github.com/vinceliuice/Nordzy-icon) |
| Catppuccin cursors (Latte/Mocha) | [github.com/catppuccin/cursors](https://github.com/catppuccin/cursors) |
| WhiteSur-cursors | [github.com/vinceliuice/WhiteSur-cursors](https://github.com/vinceliuice/WhiteSur-cursors) |
| Sweet-cursors | [github.com/EliverLara/Sweet](https://github.com/EliverLara/Sweet) |
| Nordic-cursors | Part of Nordic theme |
| Layan-border-cursors | [github.com/vinceliuice/Layan-gtk-theme](https://github.com/vinceliuice/Layan-gtk-theme) |
| Various KDE color schemes | Catppuccin, WhiteSur, Sweet, Nordic, Layan (see `~/.local/share/color-schemes/`) |
| Various Aurorae themes | Catppuccin, WhiteSur, Sweet, Nordic, Layan (see `~/.local/share/aurorae/themes/`) |
