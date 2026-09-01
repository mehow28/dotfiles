#!/bin/bash
kitty --class weather-window -e bash -c 'curl wttr.in/Opole; read -p "Press enter to close..."' &
