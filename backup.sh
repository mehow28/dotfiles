#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_SRC="$HOME/.config"

DIRS=(
    hypr
    waybar
    rofi
    dunst
    swaync
    wlogout
    swaylock
    gtk-3.0
    gtk-4.0
    nwg-look
    qt6ct
)

KVANTUM_FILES=(
    kvantum.kvconfig
)

EXCLUDES=(
    --exclude="*.backup-*"
    --exclude="*.backup-broken*"
    --exclude="*.old"
    --exclude="sessions"
    --exclude="start-hyprland-fixed.sh"
)

echo "=== Dotfiles Backup ==="
echo "Target: $DOTFILES_DIR"
echo ""

mkdir -p "$DOTFILES_DIR"

for dir in "${DIRS[@]}"; do
    src="$CONFIG_SRC/$dir"
    if [ -d "$src" ] || [ -e "$src" ]; then
        echo "[sync] .config/$dir/"
        rsync -av --delete "${EXCLUDES[@]}" "$src/" "$DOTFILES_DIR/.config/$dir/"
    else
        echo "[skip] .config/$dir/ (not found)"
    fi
done

echo ""
echo "[sync] .config/Kvantum/ (kvconfig only)"
mkdir -p "$DOTFILES_DIR/.config/Kvantum"
for f in "${KVANTUM_FILES[@]}"; do
    if [ -e "$CONFIG_SRC/Kvantum/$f" ]; then
        rsync -av "$CONFIG_SRC/Kvantum/$f" "$DOTFILES_DIR/.config/Kvantum/"
    fi
done

echo ""
echo "=== Done! ==="
echo "Files synced to $DOTFILES_DIR/"
