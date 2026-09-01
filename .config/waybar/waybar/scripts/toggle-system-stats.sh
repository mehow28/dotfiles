#!/bin/bash

# Check if system stats window is already open
if hyprctl clients | grep -q "title: SystemStats"; then
    # Close it
    hyprctl dispatch closewindow "title:SystemStats"
else
    # Open floating kitty with btop
    # Position: right side, below waybar (1270,35)
    kitty --title "SystemStats" \
          --class "floating-system-stats" \
          -o remember_window_size=no \
          -o initial_window_width=640 \
          -o initial_window_height=600 \
          -o background_opacity=0.9 \
          --override placement_strategy=top-left \
          -e btop &
fi
