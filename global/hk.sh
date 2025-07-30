#!/bin/bash

#hotkeys 

SHORTCUTS="$HOME/.config/kglobalshortcutsrc"
cp "$SHORTCUTS" "${SHORTCUTS}.bak.$(date +%s)"

set_shortcut() {
  kwriteconfig5 --file kglobalshortcutsrc --group "$1" --key "$2" "$3,$3,Default"
}

# Meta+Enter → Alacritty
set_shortcut "krunner" "Run Command" "Meta+A"  # KRunner
# Terminal Launch:
set_shortcut "khotkeys" "alacritty.desktop" "Meta+Return"
# Browser:
set_shortcut "khotkeys" "brave-browser.desktop" "Meta+B"
# File Manager:
set_shortcut "khotkeys" "dolphin.desktop" "Meta+E"
# Fenster Maximieren Meta+F via kwin:
kwriteconfig5 --file kwinrc --group "ModifierOnlyShortcuts" --key "Meta+F" "org.kde.kglobalaccel,/component/kwin,invokeShortcut,Window Maximize"

echo "Hotkeys gesetzt. Bitte Plasma neu starten oder abmelden."
