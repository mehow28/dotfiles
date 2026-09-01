#!/bin/bash

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
CONFIG_SRC="$HOME/.config"

CONFIG_DIRS=(
    hypr
    kitty
    waybar
    rofi
    dunst
    swaync
    wlogout
    swaylock
    swayosd
    qylock
    gtk-3.0
    gtk-4.0
    nwg-look
    qt6ct
)

LOCAL_DIRS=(
    quickshell-lockscreen:.local/share/quickshell-lockscreen
)

KVANTUM_FILES=(
    kvantum.kvconfig
)

EXCLUDES=(
    --exclude="*.backup-*"
    --exclude="*.backup-broken*"
    --exclude="*.old"
    --exclude="themes_link"
    --exclude="sessions"
)

echo "=== Dotfiles Backup ==="
echo "Target: $DOTFILES_DIR"
echo ""

mkdir -p "$DOTFILES_DIR"

for dir in "${CONFIG_DIRS[@]}"; do
    src="$CONFIG_SRC/$dir"
    if [ -d "$src" ] || [ -e "$src" ]; then
        echo "[sync] .config/$dir/"
        mkdir -p "$DOTFILES_DIR/.config/$dir"
        rsync -av --delete --delete-excluded "${EXCLUDES[@]}" "$src/" "$DOTFILES_DIR/.config/$dir/"
    else
        echo "[skip] .config/$dir/ (not found)"
    fi
done

for entry in "${LOCAL_DIRS[@]}"; do
    dir="${entry%%:*}"
    dest="${entry##*:}"
    src="$HOME/$dest"
    if [ -d "$src" ] || [ -e "$src" ]; then
        echo "[sync] $dest/"
        mkdir -p "$DOTFILES_DIR/$dest"
        rsync -av --delete "${EXCLUDES[@]}" "$src/" "$DOTFILES_DIR/$dest/"
    else
        echo "[skip] $dest/ (not found)"
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
