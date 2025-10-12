#! /bin/bash

echo O | sudo pacman -U packages/yay/yay-12.5.2-2-x86_64.pkg.tar.zst packages/yay/yay-debug-12.5.2-2-x86_64.pkg.tar.zst

yay -S topgrade-bin

echo O | sudo pacman -Syu vlc ffmpeg upower power-profiles-daemon gnome-power-manager gnome-bluetooth flatpak wget gnome-shell-extensions gnome-shell-extension-caffeine
#remote flathub

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak --user install flathub org.onlyoffice.desktopeditors io.gitlab.librewolf-community dev.zed.Zed page.codeberg.libre_menu_editor.LibreMenuEditor io.github.ungoogled_software.ungoogled_chromium

echo O | sudo pacman -Rns epiphany

cp packages/dash-to-dock@micxgx.gmail.com ~/.local/share/gnome-shell/gnome-extensions enable dash-to-dock@micxgx.gmail.com

rm ~/.var/app/dev.zed.Zed/config/zed/settings.json

mkdir ~/.local/share/icons/update
mkdir ~/.local/share/icons/monlycee

cp assets/conf/zed/zed.json ~/.var/app/dev.zed.Zed/config/zed/settings.json
cp assets/icons/monlycee.png ~/.local/share/icons/monlycee/icon.png
cp assets/conf/MonLycee.desktop ~/.local/share/applications
cp assets/icons/update.png ~/.local/share/icons/update/icon.png
cp assets/conf/Update.desktop ~/.local/share/applications

sudo systemctl reboot
