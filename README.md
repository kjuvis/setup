

```markdown
# 🛠️ Multi-Distro Post-Install-Script – Fedora & Arch

Dieses Repository enthält automatisierte Setup-Skripte zur Post-Installation von **Fedora** und **Arch Linux** Systemen (mit Fokus auf KDE)

---

## 📦 Unterstützte Distributionen

| Distribution | Status      | Desktop |
|--------------|-------------|---------|
| Arch Linux   | ✅ Fertig    | KDE     |
| Fedora       | ✅ Fertig    | KDE     |

---

## 🚀 Funktionen (beide Setups)

- Automatische Softwareinstallation (Discord, Spotify, Brave, VS Code uvm.)
- Einrichtung von AUR (`yay`) auf Arch oder RPM Fusion auf Fedora
- Flatpak & Flathub Einrichtung
- Zsh als Standard-Shell
- KDE Breeze Dark Theme als Standard
- Brave als Standardbrowser, Alacritty als Standard-Terminal
- Firewall-Konfiguration via `ufw` (Arch) oder `firewalld` (Fedora)
- Auswahlmenü für Grafiktreiber (AMD, NVIDIA oder keiner)

---

## 🧑‍💻 Nutzung


```bash
git clone https://github.com/kjuvis/setup.git
cd setup
sh setup.sh
```

---

## 📋 Enthaltene Software

| Kategorie    | Pakete (Beispiele)                                   |
| ------------ | ---------------------------------------------------- |
| Browser      | Brave (Standardbrowser)                              |
| Chat & Voice | Discord, Spotify                                     |
| Entwicklung  | VS Code, Git,                                        |
| Terminal     | Alacritty (Standardterminal), Zsh                    |
| Themes & UI  | KDE Breeze Dark, Zsh-Konfiguration                   |
| Multimedia   | VLC, Mediencodecs                                    |
| Treiber      | Auswahlmenü für NVIDIA/AMD oder „keine Installation“ |

---

## 🔧 Anpassung

Du kannst die Skripte beliebig anpassen:

* Weitere Programme oder Pakete hinzufügen
* Konfigurationen für andere Desktops (z. B. GNOME)
* Dotfiles oder Themes integrieren

---

## 🛡️ Sicherheitshinweis

Alle Skripte führen Systembefehle mit `sudo` aus – lies den Code sorgfältig, bevor du ihn auf deinem System verwendest.

---

## 🤝 Mitwirken

Pull Requests, Issues oder Feature-Vorschläge sind herzlich willkommen!
Hilf mit, das Setup noch besser und flexibler zu machen.

---

## 📄 Lizenz

MIT License – siehe ggf. [LICENSE](LICENSE)

---
