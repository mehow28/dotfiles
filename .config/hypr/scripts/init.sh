#!/usr/bin/env bash

WALLPAPER="$HOME/.cache/wallpaper_current"
RELOAD_SCRIPT_PATH="$HOME/.config/hypr/scripts/quickshell/wallpaper/matugen_reload.sh"

if [ ! -f "$WALLPAPER" ]; then
    WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
    file=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | shuf -n 1)
    if [ -n "$file" ]; then
        cp "$file" "$WALLPAPER"
    fi
fi

if [ -f "$WALLPAPER" ]; then
    sleep 0.5
    awww img "$WALLPAPER" --transition-type none &
    matugen image "$WALLPAPER" --source-color-index 0

    if [ -f "$RELOAD_SCRIPT_PATH" ]; then
        chmod +x "$RELOAD_SCRIPT_PATH"
        bash "$RELOAD_SCRIPT_PATH"
    fi
fi
