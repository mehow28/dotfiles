#!/bin/bash

# Skrypt pokazuje stan baterii (jeśli istnieje)
battery_path="/sys/class/power_supply/BAT0"

if [ -d "$battery_path" ]; then
    capacity=$(cat "$battery_path/capacity")
    status=$(cat "$battery_path/status")
    
    if [ "$status" = "Charging" ]; then
        icon=""
    elif [ "$capacity" -ge 90 ]; then
        icon=""
    elif [ "$capacity" -ge 60 ]; then
        icon=""
    elif [ "$capacity" -ge 30 ]; then
        icon=""
    elif [ "$capacity" -ge 10 ]; then
        icon=""
    else
        icon=""
    fi
    
    echo "$icon $capacity%"
else
    echo ""
fi
