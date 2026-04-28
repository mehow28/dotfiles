# Dotfiles Backup

CachyOS Hyprland rice, based on [ilyamiro/nixos-configuration](https://github.com/ilyamiro/nixos-configuration) with [qylock](https://github.com/Darkkal44/qylock) lockscreen. Heavily tweaked.

## Backed Up Configs

| Path | Description |
|---|---|
| `.config/hypr/` | Hyprland compositor — modular config structure (`config/` subdirectory), Quickshell UI panels, custom scripts, matugen colors, hypridle |
| `.config/hypr/scripts/quickshell/` | Quickshell UI — app launcher, top bar, notifications, music player, volume, network, battery, calendar, clipboard, screenshot, wallpaper picker, focustime, monitors, settings, guide |
| `.local/share/quickshell-lockscreen/` | qylock Quickshell lockscreen (currently using `pixel-night-city` theme) |
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

## Scripts

- **`backup.sh`** — Sync dotfiles into this repo (run before/after making rice changes)
- **`push.sh`** — Commit and push to GitHub (`push.sh "optional message"`)

## Not Backed Up (System-Level)

These live outside user config and require manual setup:

### SDDM Login Theme (qylock)
Config at `/etc/sddm.conf.d/`:
- `10-wayland-matugen.conf` — matugen integration for SDDM
- `hyprland.conf` — Hyprland session config
- `theme.conf` — currently set to `pixel-skyscrapers`
- `zzz-x11-override.conf` — X11 fallback

qylock is cloned at `~/Boniland/qylock/`. To reinstall:
```bash
git clone https://github.com/Darkkal44/qylock.git ~/Boniland/qylock
cd ~/Boniland/qylock && chmod +x sddm.sh && ./sddm.sh
```

## Active Themes / Dependencies

### In Use
| Component | Value | Source |
|---|---|---|
| GTK theme | `adw-gtk3-dark` | Standard Arch package (`extra/adw-gtk3`) |
| Icon theme | `Tela-dark` | [github.com/vinceliuice/Tela-icon-theme](https://github.com/vinceliuice/Tela-icon-theme) |
| Kvantum theme | `catppuccin-mocha-peach` | [github.com/catppuccin/Kvantum](https://github.com/catppuccin/Kvantum) |
| Color scheme | Matugen-generated | [github.com/InioX/matugen](https://github.com/InioX/matugen) — generates colors from wallpaper |
| Font | JetBrains Mono | Standard Arch package (`extra/ttf-jetbrains-mono`) |
| Lockscreen theme | `pixel-night-city` | qylock (see above) |
| SDDM theme | `pixel-skyscrapers` | qylock (see above) |

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
