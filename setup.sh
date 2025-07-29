#!/bin/bash
set -e

echo "=== System Setup Auswahl ==="
echo "1) Arch-Linux"
echo "2) Fedora"
read -rp "Bitte wählen Sie 1 oder 2: " choice

case "$choice" in
  1)
    echo "Starte Arch-Linux..."
    cd distro
    sudo sh arch.sh
    ;;
  2)
    echo "Starte Fedora..."
    cd distro
    sudo sh fedora.sh
    ;;
  *)
    echo "Ungültige Auswahl – Skript beendet."
    exit 1
    ;;
esac

echo "Setup abgeschlossen."
