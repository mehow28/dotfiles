#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# AUDIO STATE RESTORER - Przywraca stan audio przy starcie
# ═══════════════════════════════════════════════════════════════════════════

STATE_FILE="$HOME/.config/hypr/audio-state.conf"
MAX_VOLUME="0.40"  # 40%

# Czekaj aż PipeWire będzie gotowe
sleep 2

# Jeśli nie ma zapisanego stanu, użyj domyślnych wartości
if [[ ! -f "$STATE_FILE" ]]; then
    echo "⚠️  No saved audio state, using defaults"
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$MAX_VOLUME"
    exit 0
fi

# Wczytaj zapisany stan
source "$STATE_FILE"

# Ogranicz głośność do max 40%
VOLUME_COMPARE=$(echo "$VOLUME > $MAX_VOLUME" | bc -l)
if [[ "$VOLUME_COMPARE" == "1" ]]; then
    TARGET_VOLUME="$MAX_VOLUME"
    echo "📉 Volume capped: $VOLUME -> $MAX_VOLUME"
else
    TARGET_VOLUME="$VOLUME"
    echo "✅ Restored volume: $VOLUME"
fi

# Sprawdź czy zapisane urządzenie jeszcze istnieje
if wpctl status | grep -q "${SINK_ID}\."; then
    # Urządzenie istnieje - ustaw jako domyślne
    wpctl set-default "$SINK_ID"
    echo "✅ Restored sink: $SINK_ID"
    
    # Ustaw głośność i odmutuj NA TYM KONKRETNYM URZĄDZENIU
    sleep 0.5  # Daj chwilę na przełączenie
    wpctl set-volume "$SINK_ID" "$TARGET_VOLUME"
    wpctl set-mute "$SINK_ID" 0
else
    echo "⚠️  Saved sink $SINK_ID not found, using current default"
    # Ustaw na bieżącym default
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$TARGET_VOLUME"
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
fi

echo "🔊 Audio restored successfully!"
