#!/bin/bash

CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}')
CPU_TEMP_RAW=$(cat /sys/class/hwmon/hwmon2/temp1_input)
CPU_TEMP_C=$((CPU_TEMP_RAW / 1000))

echo "CPU: ${CPU_USAGE}% ${CPU_TEMP_C}°C"