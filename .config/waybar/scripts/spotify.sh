#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Spotify Now Playing Widget dla Waybar
# Z obsługą scrollowania dla długich tytułów
# ═══════════════════════════════════════════════════════════

# Pobierz info z Spotify konkretnie
title=$(playerctl metadata --player=spotify title 2>/dev/null)

if [ -z "$title" ]; then
    echo "spotify"
    exit 0
fi

artist=$(playerctl metadata --player=spotify artist 2>/dev/null)
album=$(playerctl metadata --player=spotify album 2>/dev/null)
player_status=$(playerctl status --player=spotify 2>/dev/null)

# Długość bez scrollowania (około 30 znaków zmieści się w widget)
scroll_threshold=30

# Ustal output
if [ -n "$artist" ] && [ "$artist" != "" ]; then
    output="$artist - $title"
elif [ -n "$album" ] && [ "$album" != "" ]; then
    output="$album - $title"
else
    output="$title"
fi

# Sprawdź czy output nie jest pusty po trimowaniu whitespace
output_trimmed=$(echo "$output" | xargs)
if [ -z "$output_trimmed" ] || [ "$output_trimmed" = "-" ]; then
    echo "podcast"
    exit 0
fi

# Ikona w zależności od statusu
if [ "$player_status" = "Playing" ]; then
    icon="▶"
else
    icon="⏸"
fi

# Jeśli tekst jest za długi, dodaj klasę scrolling
if [ ${#output} -gt $scroll_threshold ]; then
    # HTML z animacją marquee
    echo "<span class=\"scrolling\">$icon $output</span>"
else
    # Krótki tekst - bez scrollowania
    echo "$icon $output"
fi
