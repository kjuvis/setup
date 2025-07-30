#!/bin/bash

echo "Treiber"
  cd "$SCRIPT_DIR/global/"
  sh treiber.sh

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

echo "🧩 Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


echo "🌐 Flathub hinzufügen als Flatpak-Quelle..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || { echo "❌ Fehler beim Hinzufügen von Flathub"; exit 1; }

echo "Snapd wird installiert"
sudo dnf install snapd -y
sudo ln -s /var/lib/snapd/snap /snap || true
sudo systemctl enable --now snapd.socket

echo "snap und flatpak install"
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub com.discordapp.Discord
sudo snap install obsidian --classic
  
echo "=> Weitere Programme"
  sudo dnf install git zsh btop obs-studio java-latest-openjdk java-latest-openjdk-devel krita fastfetch alacritty vlc protonvpn-cli -y
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 
  sudo dnf install code -y
  echo "Brave"
  sudo dnf install dnf-plugins-core -y
  sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
  sudo dnf install brave-browser -y


echo "zsh"
  cd "$SCRIPT_DIR/global/"
  sh zsh.sh

echo "config"
  cd "$SCRIPT_DIR/global/"
  sh config.sh

echo "hotkeys"
  cd "$SCRIPT_DIR/global/"
  sh hk.sh

echo "installiert global datei"
  cd "$SCRIPT_DIR/global/"
  sh global.sh
echo "look and feel + defaultprogramme gesetzt"


echo "⚙️ Setting Zsh as default shell..."
chsh -s $(which zsh)