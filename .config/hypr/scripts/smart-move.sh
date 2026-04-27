#!/bin/bash

# Pobierz aktywne okno
WINDOW=$(hyprctl activewindow -j)

# Sprawdź czy istnieje aktywne okno
if [[ -z "$WINDOW" ]]; then
    exit 1
fi

# Pobierz wymiary i pozycję okna
X=$(echo "$WINDOW" | jq '.at[0]')
Y=$(echo "$WINDOW" | jq '.at[1]')
WIDTH=$(echo "$WINDOW" | jq '.size[0]')
HEIGHT=$(echo "$WINDOW" | jq '.size[1]')

# Pobierz monitor aktywnego okna
MONITOR=$(hyprctl monitors -j | jq -r "[.[] | select(.name == $(echo "$WINDOW" | jq '.monitor'))][0]")

if [[ -z "$MONITOR" ]]; then
    exit 1
fi

MON_WIDTH=$(echo "$MONITOR" | jq '.width')
MON_HEIGHT=$(echo "$MONITOR" | jq '.height')
MON_X=$(echo "$MONITOR" | jq '.x')
MON_Y=$(echo "$MONITOR" | jq '.y')

# Oblicz środek okna względem monitora (uwzględniając pozycję monitora)
REL_CENTER_X=$((X - MON_X + WIDTH / 2))
REL_CENTER_Y=$((Y - MON_Y + HEIGHT / 2))

# Pobierz kierunek z argumentu
DIRECTION="$1"

case "$DIRECTION" in
    l)
        # Jeśli środek okna jest w lewej 1/3 monitora → przenieś na lewy monitor
        if [[ $REL_CENTER_X -lt $((MON_WIDTH / 3)) ]]; then
            hyprctl dispatch movewindow mon:l
        else
            hyprctl dispatch movewindow l
        fi
        ;;
    r)
        # Jeśli środek okna jest w prawej 1/3 monitora → przenieś na prawy monitor
        if [[ $REL_CENTER_X -gt $((MON_WIDTH * 2 / 3)) ]]; then
            hyprctl dispatch movewindow mon:r
        else
            hyprctl dispatch movewindow r
        fi
        ;;
    u)
        # Jeśli środek okna jest w górnej 1/3 monitora → przenieś na górny monitor
        if [[ $REL_CENTER_Y -lt $((MON_HEIGHT / 3)) ]]; then
            hyprctl dispatch movewindow mon:u
        else
            hyprctl dispatch movewindow u
        fi
        ;;
    d)
        # Jeśli środek okna jest w dolnej 1/3 monitora → przenieś na dolny monitor
        if [[ $REL_CENTER_Y -gt $((MON_HEIGHT * 2 / 3)) ]]; then
            hyprctl dispatch movewindow mon:d
        else
            hyprctl dispatch movewindow d
        fi
        ;;
esac
