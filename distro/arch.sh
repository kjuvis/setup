#!/bin/bash
set -e

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
sleep 2


# 1. System aktualisieren
echo "System aktualisieren..."
sudo pacman -Syu --noconfirm

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

echo "💡 Preparing Zsh plugins..."
touch ~/.zshrc
mkdir -p ~/.zsh/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/plugins/zsh-completions

echo "📜 Updating .zshrc with plugin configuration..."
cat << 'EOF' >> ~/.zshrc

# Plugin Paths
fpath+=~/.zsh/plugins/zsh-completions

# Load Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -Uz compinit && compinit
EOF

#source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

echo "=> Installiere Alacritty-Konfiguration..."
  mkdir -p ~/.config/alacritty
  cd ~/setup/
  cp /config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
  echo "✓ Alacritty-Konfiguration kopiert."

echo "=> Installiere Fastfetch-Konfiguration..."
  mkdir -p ~/.config/fastfetch
   cd ~/setup/
  cp /config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
  echo "✓ Fastfetch-Konfiguration kopiert."

echo "=> zsh config"
 cd ~/setup/
 cp /config/zsh/.zshrc ~/
cd ~/setup/
 cp /config/zsh/.p10k.zsh ~/
 echo "fertig"


# 8. Flatpak Repository hinzufügen (flathub)
echo "Füge Flathub Flatpak Repository hinzu..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "=> Installiere snapd..."

# AUR-Installation mit yay (ohne Bestätigung)
if command -v yay &> /dev/null; then
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

# systemd socket aktivieren
echo "=> Aktiviere snapd.socket..."
sudo systemctl enable --now snapd.socket
echo "✓ snapd.socket aktiviert"

# Symlink für /snap erstellen (für classic Snaps)
echo "=> Erstelle Symlink /snap..."
sudo ln -sf /var/lib/snapd/snap /snap
echo "✓ Symlink erstellt"


# 4. AUR Pakete installieren via yay (discord, spotify, brave-bin, visual-studio-code-bin)
echo "Installiere AUR Pakete via yay..."
yay -S --noconfirm --needed discord spotify brave-bin visual-studio-code-bin obsidian protonvpn-cli-ng

echo "Look and Feel"
lookandfeeltool -a org.kde.breezedark.desktop
plasma-apply-colorscheme BreezeDark

xdg-settings get default-web-browser
xdg-mime default brave-browser.desktop x-scheme-handler/http
xdg-mime default brave-browser.desktop x-scheme-handler/https

xdg-mime default vlc.desktop video/x-matroska
xdg-mime default vlc.desktop video/mp4
xdg-mime default vlc.desktop video/x-msvideo
xdg-mime default vlc.desktop audio/mpeg
xdg-mime default vlc.desktop audio/x-wav
xdg-mime default vlc.desktop audio/x-flac
xdg-mime default vlc.desktop audio/ogg
xdg-mime default vlc.desktop audio/mp4
xdg-mime default vlc.desktop application/ogg

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