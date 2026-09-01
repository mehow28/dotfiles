#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Weather Widget dla Waybar - Minimalistic
# Używa wttr.in API
# ═══════════════════════════════════════════════════════════

# Lokalizacja (możesz zmienić na swoją)
LOCATION="Opole"

# Pobierz dane pogodowe w jednym zapytaniu - ikona emoji + temperatura
weather_data=$(curl -s -m 5 "wttr.in/${LOCATION}?format=%c+%t" 2>/dev/null)

if [ -n "$weather_data" ] && [ "$weather_data" != "Unknown location" ]; then
    # Wyczyść białe znaki i wyświetl
    echo "$weather_data" | tr -s ' '
else
    echo "❓ N/A"
fi
