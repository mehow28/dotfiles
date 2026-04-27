#!/bin/bash

# Get CPU usage percentage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_usage=$(printf "%.0f" "$cpu_usage")

# Get CPU temp
cpu_temp=$(sensors 2>/dev/null | grep -i 'package id 0' | awk '{print $4}' | tr -d '+°C' | cut -d'.' -f1)
if [ -z "$cpu_temp" ]; then
    cpu_temp=$(sensors 2>/dev/null | grep -i 'tctl' | awk '{print $2}' | tr -d '+°C' | cut -d'.' -f1)
fi
if [ -z "$cpu_temp" ]; then
    cpu_temp="--"
fi

# Get RAM usage
ram_used=$(free -g | awk '/^Mem:/ {printf "%.1f", $3}')

# Get network interface
net_iface=$(ip route | grep default | awk '{print $5}' | head -1)

# Get network bandwidth (read RX/TX bytes and calculate diff)
if [ -n "$net_iface" ]; then
    # Get current RX/TX bytes
    rx_bytes=$(cat /sys/class/net/$net_iface/statistics/rx_bytes 2>/dev/null || echo "0")
    tx_bytes=$(cat /sys/class/net/$net_iface/statistics/tx_bytes 2>/dev/null || echo "0")
    
    # Cache file for previous values
    cache_file="/tmp/waybar_net_$net_iface"
    
    if [ -f "$cache_file" ]; then
        # Read previous values
        read prev_rx prev_tx prev_time < "$cache_file"
        current_time=$(date +%s)
        time_diff=$((current_time - prev_time))
        
        if [ $time_diff -gt 0 ]; then
            # Calculate bandwidth in KB/s
            rx_rate=$(( (rx_bytes - prev_rx) / time_diff / 1024 ))
            tx_rate=$(( (tx_bytes - prev_tx) / time_diff / 1024 ))
            net_info="↓${rx_rate}KB/s ↑${tx_rate}KB/s"
        else
            net_info="⏳ calculating..."
        fi
    else
        net_info="⏳ calculating..."
    fi
    
    # Save current values
    echo "$rx_bytes $tx_bytes $(date +%s)" > "$cache_file"
else
    net_info="📡 offline"
fi

# Output combined info with emoji
echo "🌡️${cpu_temp}°C 💻${cpu_usage}% 🧠${ram_used}G ${net_info}"
