#!/usr/bin/env bash
# Sprawdza które GPU używa Hyprland i Aquamarine

echo "=== GPU Detection Check ==="
echo ""
echo "🔍 Dostępne karty graficzne:"
ls -la /dev/dri/by-path/ | grep -E "card|render"
echo ""

echo "🎮 Twoje GPU:"
lspci | grep VGA
echo ""

echo "📊 Hyprland używa:"
hyprctl monitors | grep -A 5 "Monitor"
echo ""

echo "🔧 DRM devices (priorytet):"
echo "  WLR_DRM_DEVICES: $WLR_DRM_DEVICES"
echo "  AQ_DRM_DEVICES: $AQ_DRM_DEVICES"
echo ""

echo "✅ Oczekiwane:"
echo "  - Monitory podłączone do RX 6700 XT (PCI 03:00.0)"
echo "  - AQ_DRM_DEVICES: /dev/dri/by-path/pci-0000:03:00.0-card"
echo "  - Brak błędów 'Cannot commit when a page-flip is awaiting'"
echo ""

# Sprawdź ostatnie błędy DRM w logach
echo "⚠️  Ostatnie błędy DRM (jeśli są):"
journalctl --user -u hyprland --since "5 minutes ago" --no-pager | grep -i "drm\|page-flip\|aquamarine" | tail -10
