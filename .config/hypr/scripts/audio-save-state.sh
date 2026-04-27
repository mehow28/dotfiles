#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# AUDIO STATE SAVER - Zapisuje stan audio przed shutdownem
# ═══════════════════════════════════════════════════════════════════════════

STATE_FILE="$HOME/.config/hypr/audio-state.conf"

# Pobierz ID aktualnego urządzenia
CURRENT_SINK=$(wpctl status | grep -A 999 "Sinks:" | grep "\*" | head -1 | sed 's/.*\*\s*\([0-9]*\)\..*/\1/')

# Pobierz głośność (bez MUTED)
CURRENT_VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')

# Zapisz do pliku
cat > "$STATE_FILE" << EOF
# Audio state saved at $(date)
SINK_ID=$CURRENT_SINK
VOLUME=$CURRENT_VOLUME
EOF

echo "✅ Audio state saved: Sink=$CURRENT_SINK, Volume=$CURRENT_VOLUME"
