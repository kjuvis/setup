#!/bin/bash
#ändert look und serzt defaultprogramme

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
