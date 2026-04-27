#!/bin/bash

# Sprawdź czy Spotify jest otwarty (wykluczając ten skrypt)
if pgrep -x spotify > /dev/null || pgrep -f "spotify-launcher/install" > /dev/null; then
    # Spotify jest otwarty - przełącz na workspace 2 i daj focus
    hyprctl dispatch workspace 2
    sleep 0.1
    hyprctl dispatch focuswindow "class:^(spotify)$"
else
    # Spotify nie jest otwarty - przejdź na workspace 2 i uruchom
    hyprctl dispatch workspace 2
    /usr/bin/spotify-launcher > /dev/null 2>&1 &
fi
