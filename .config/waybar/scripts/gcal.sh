#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Google Calendar Widget dla Waybar
# Pokazuje datę i (opcjonalnie) najbliższe wydarzenie
# 
# Pełna integracja wymaga:
# - gcalcli (AUR: gcalcli)
# - Google Calendar API authentication
# 
# Obecnie: prosty widget daty z opcjonalną integracją
# ═══════════════════════════════════════════════════════════

# Sprawdź czy gcalcli jest zainstalowane
if command -v gcalcli &> /dev/null; then
    # Pobierz najbliższe wydarzenie
    next_event=$(gcalcli agenda --nostarted --nodeclined --calendar "primary" "$(date +%Y-%m-%d)" "$(date -d '+1 day' +%Y-%m-%d)" 2>/dev/null | head -1)
    
    if [ -n "$next_event" ]; then
        echo " $(date +'%d.%m') | $next_event"
    else
        echo " $(date +'%A, %d %B %Y')"
    fi
else
    # Fallback: tylko dzisiejsza data
    echo " $(date +'%A, %d.%m.%Y')"
fi
