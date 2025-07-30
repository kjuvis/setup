#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME=$(eval echo ~$SUDO_USER)


echo "Treiber"
bash "$SCRIPT_DIR/global/treiber.sh"


#System aktualisieren
echo "System aktualisieren..."
sudo pacman -Syu --noconfirm

#install flatpak und snap
sudo pacman -S --noconfirm --needed flatpak
echo "Füge Flathub Flatpak Repository hinzu..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "=> Installiere snapd..."
if command -v yay &> /dev/null; then          # AUR-Installation mit yay (ohne Bestätigung)
  yay -S --noconfirm snapd
else
  echo "yay nicht gefunden. Versuche manuelle Installation..."
  cd /tmp
  rm -rf snapd
  git clone https://aur.archlinux.org/snapd.git
  cd snapd
  makepkg -si --noconfirm
fi
echo "✓ snapd installiert"
echo "=> Aktiviere snapd.socket..."           # systemd socket aktivieren
sudo systemctl enable --now snapd.socket
echo "✓ snapd.socket aktiviert"
echo "=> Erstelle Symlink /snap..."           # Symlink für /snap erstellen (für classic Snaps)
sudo ln -sf /var/lib/snapd/snap /snap
echo "✓ Symlink erstellt"

# 2. Basis-Pakete installieren (inkl. wichtige Tools ohne NM, Firefox, PulseAudio, pavucontrol)
echo "Installiere Basis-Pakete und wichtige Programme..."

sudo pacman -S --noconfirm --needed git base-devel zsh flatpak ufw alacritty kdeconnect vim htop wget curl unzip tar gzip fastfetch vlc 

# 3. Yay installieren (AUR Helper)
# Bestimme den primären Benutzer, egal ob das Skript als Root läuft oder nicht
if [ "$EUID" -eq 0 ]; then
    USERNAME=$(logname)  # Liefert den "echten" Benutzer bei sudo
else
    USERNAME=$(whoami)
fi

# Prüfe, ob yay vorhanden ist
if ! command -v yay &> /dev/null; then
    echo "yay nicht gefunden, installiere als $USERNAME..."

    sudo -u "$USERNAME" bash -c '
        set -e
        cd /tmp
        rm -rf yay 2>/dev/null || true
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    '
fi


# 4. AUR Pakete installieren via yay (discord, spotify, brave-bin, visual-studio-code-bin)
echo "Installiere AUR Pakete via yay..."
yay -S --noconfirm --needed discord spotify brave-bin visual-studio-code-bin obsidian protonvpn-cli-ng


echo "zsh"
bash "$SCRIPT_DIR/global/zsh.sh"

echo "config"
bash "$SCRIPT_DIR/global/config.sh"

echo "hotkeys"
bash "$SCRIPT_DIR/global/hk.sh"

echo "installiert global datei"
bash "$SCRIPT_DIR/global/look.sh"
echo "look and feel + defaultprogramme gesetzt"


# 5. UFW Firewall aktivieren und konfigurieren
echo "Konfiguriere UFW Firewall..."
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

echo "⚙️ Setting Zsh as default shell..."
chsh -s $(which zsh)