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
    sudo dnf install -y mesa-vulkan-drivers mesa-va-drivers libva-utils
    ;;
  2)
    echo "🟡 NVIDIA-Treiber wird installiert..."
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
    sudo dnf install -y xorg-x11-drv-nvidia-power
    ;;
  3)
    echo "⚪ Kein Grafiktreiber wird installiert."
    ;;
  *)
    echo "❌ Ungültige Auswahl. Es wird kein Treiber installiert."
    ;;
esac

echo "✅ GPU-Setup abgeschlossen."
echo "➡️ Fortsetzung des Fedora-Setups ..."
sleep 2

# --------------------------
# Der Rest deines Scripts
# (Pakete installieren, Dotfiles kopieren, Flatpak etc.)
# --------------------------

# Exit on error
set -e

echo "🔄 Updating system..."
sudo dnf update -y

echo "📦 Enabling RPM Fusion repositories..."
sudo dnf install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

echo "🎥 Enabling OpenH264 codec..."
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

echo "🔄 Replacing ffmpeg-free with full ffmpeg..."
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

echo "🎶 Updating multimedia group without weak dependencies..."
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y

echo "🛠️ Installing Git and Zsh..."
sudo dnf install git zsh -y

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

#!/bin/bash
set -e

echo "=> Starte Konfigurationsinstallation..."

# Ermittle Setup-Verzeichnis (z. B. ~/setup)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME=$(eval echo ~$SUDO_USER)

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


echo "🧩 Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


echo "🌐 Flathub hinzufügen als Flatpak-Quelle..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || { echo "❌ Fehler beim Hinzufügen von Flathub"; exit 1; }

echo "🚀 Installiere Flatpak-Apps..."
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub com.discordapp.Discord

echo "Snapd wird installiert"
sudo dnf install snapd -y
sudo ln -s /var/lib/snapd/snap /snap || true
sudo systemctl enable --now snapd.socket

sudo snap install obsidian --classic
sudo dnf install -y protonvpn-cli
  
 echo "=> Weitere Programme"
  sudo dnf install btop obs-studio java-latest-openjdk java-latest-openjdk-devel krita fastfetch alacritty vlc -y

echo "VS-Code"
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 
  sudo dnf install code -y
  echo "Brave"
  sudo dnf install dnf-plugins-core -y
  sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
  sudo dnf install brave-browser -y

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


echo "⚙️ Setting Zsh as default shell..."
chsh -s $(which zsh)