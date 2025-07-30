#!/bin/bash

# Auswahlmenü: GPU-Treiber
echo "----------------------------------"
echo " 🎮 Wähle deinen Grafiktreiber:"
echo " 1) AMD"
echo " 2) NVIDIA"
echo " 3) Keiner"
echo "----------------------------------"
read -rp "Deine Auswahl [1-3]: " GPU_CHOICE

case "$GPU_CHOICE" in
  1)
    echo "🟣 AMD-Treiber wird installiert..."
    sudo pacman -S --noconfirm mesa vulkan-radeon libva-mesa-driver libva-utils
    ;;
  2)
    echo "🟡 NVIDIA-Treiber wird installiert..."
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
    ;;
  3)
    echo "⚪ Kein Grafiktreiber wird installiert."
    ;;
  *)
    echo "❌ Ungültige Auswahl. Es wird kein Treiber installiert."
    ;;
esac

echo "✅ GPU-Setup abgeschlossen."
echo "➡️ Fortsetzung des Arch-Setups ..."
