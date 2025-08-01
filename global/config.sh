#!/bin/bash

echo "=> Starte Konfigurationsinstallation..."

# Ermittle Setup-Verzeichnis (z. B. ~/setup)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"

### --- Alacritty ---
echo "=> Installiere Alacritty-Konfiguration..."
mkdir -p "$USER_HOME/.config/alacritty"
cp -v "$SCRIPT_DIR/config/alacritty/alacritty.toml" "$USER_HOME/.config/alacritty/"
echo "✓ Alacritty-Konfiguration installiert."

### --- Fastfetch ---
echo "=> Installiere Fastfetch-Konfiguration..."
mkdir -p "$USER_HOME/.config/fastfetch"
cp -v "$SCRIPT_DIR/config/fastfetch/config.jsonc" "$USER_HOME/.config/fastfetch/"
echo "✓ Fastfetch-Konfiguration installiert."

### --- ZSH ---
echo "=> Installiere ZSH-Konfiguration..."
cp -v "$SCRIPT_DIR/config/zsh/.zshrc" "$USER_HOME/"
cp -v "$SCRIPT_DIR/config/zsh/.p10k.zsh" "$USER_HOME/"
echo "✓ ZSH-Konfiguration installiert."

### --- VS Code ---
echo "=> Installiere VS Code-Konfiguration..."
VSCODE_USER_DIR="$USER_HOME/.config/Code/User"
mkdir -p "$VSCODE_USER_DIR"
cp -v "$SCRIPT_DIR/config/vscode/settings.json" "$VSCODE_USER_DIR/"
# Optional:
# cp -v "$SCRIPT_DIR/config/vscode/keybindings.json" "$VSCODE_USER_DIR/"
echo "✓ VS Code-Konfiguration installiert."

### --- Obsidian ---
echo "=> Installiere Obsidian-Konfiguration..."
VAULT_DIR="$USER_HOME/Documents/ObsidianVault"
mkdir -p "$VAULT_DIR"
cp -rv "$SCRIPT_DIR/config/obsidian/.obsidian" "$VAULT_DIR/"
echo "✓ Obsidian-Konfiguration installiert."

echo "✅ Alle Konfigurationen erfolgreich installiert."