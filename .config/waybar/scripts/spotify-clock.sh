#!/bin/bash

# Spotify + Clock combined widget - bez CSS class (używamy różnych stylów inline)

# Pobierz czas
time=$(date '+%H:%M')

# Sprawdź czy Spotify gra
player_status=$(playerctl status 2>/dev/null)

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
    # Spotify gra - pokaż spotify + clock połączone
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    
    if [ -n "$artist" ] && [ -n "$title" ]; then
        output="$artist - $title"
        
        # Ikona statusu
        if [ "$player_status" = "Playing" ]; then
            icon="▶"
        else
            icon="⏸"
        fi
        
        # Zwróć JSON z klasą "playing"
        echo '{"text":"'"$icon $output  |  $time"'","class":"playing","alt":"playing"}'
    else
        # Brak informacji - sam clock
        echo '{"text":"'"$time"'","class":"solo","alt":"solo"}'
    fi
else
    # Spotify nie gra - sam clock
    echo '{"text":"'"$time"'","class":"solo","alt":"solo"}'
fi
