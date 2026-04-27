#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Mini Audio Visualizer dla Waybar
# Tworzy 6 ASCII barów na podstawie głośności audio
# ═══════════════════════════════════════════════════════════

# Sprawdź czy pulseaudio/pipewire działa
if ! pactl info &>/dev/null; then
    echo "▁▁▁▁▁▁"
    exit 0
fi

# Pobierz aktualną głośność jako wartość 0-100
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# Jeśli muzyka nie gra, pokaż idle pattern
player_status=$(playerctl status 2>/dev/null)
if [ "$player_status" != "Playing" ]; then
    # Idle animation - static low bars
    echo "▁▂▁▂▁▂"
    exit 0
fi

# Konwertuj volume na 6 barów (0-7 wysokość każdego bara)
# Dodaj losowość bazując na czasie
RANDOM=$(date +%N | cut -c6-9)

bars=""
for i in {1..6}; do
    # Każdy bar ma wysokość bazowaną na volume + losowy modifier
    height=$((volume / 15 + RANDOM % 3))
    
    # Ogranicz do 0-7
    if [ $height -gt 7 ]; then height=7; fi
    if [ $height -lt 0 ]; then height=0; fi
    
    # Konwertuj wysokość na ASCII bar
    case $height in
        0) bars+="▁";;
        1) bars+="▂";;
        2) bars+="▃";;
        3) bars+="▄";;
        4) bars+="▅";;
        5) bars+="▆";;
        6) bars+="▇";;
        7) bars+="█";;
    esac
done

echo "$bars"
