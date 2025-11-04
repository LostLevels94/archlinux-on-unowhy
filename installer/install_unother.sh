#! /bin/bash

confirm() {
    read -rp "$* [O/n] " ans
    [[ "${ans,,}" == "O" ]]
}

read -sp "Veuillez choisir un mot de passe ADMINISTRATEUR : " admpwd
read -sp "Veuillez choisir un mot de passe UTILISATEUR : " usrpwd

timedatectl set-timezone Europe/Paris
cp assets/conf/locale.gen /etc/locale.gen
locale-gen
echo LANG=fr_FR.UTF-8 > /etc/locale.conf
export LANG=fr_FR.UTF-8

echo y13 > /etc/hostname
cp assets/conf/hosts /etc/hosts
echo $admpwd | passwd -s

pacman -S grub efibootmgr
mkdir /boot/efibootmgr
mount /dev/mmcblk0p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m lyceen
echo $usrpwd | passwd -s lyceen
usermod -aG wheel,audio,video,storage lyceen

echo "Installation des modules de base"
echo O | pacman -U packages/yay/yay-12.5.2-2-x86_64.pkg.tar.zst packages/yay/yay-debug-12.5.2-2-x86_64.pkg.tar.zst
echo O | pacman -Syu --needed base-devel git wayland xorg-xwayland networkmanager mesa xf86-video-intel vulkan-intel bluez bluez-utils gdm gnome mutter pipewire pipewire-pulse pipewire-alsa vlc ffmpeg upower power-profiles-daemon gnome-power-manager gnome-bluetooth flatpak wget gnome-shell-extensions gnome-shell-extension-caffeine elementary-icon-theme
yay -S topgrade-bin

echo "Mise en place des applications"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.onlyoffice.desktopeditors org.mozilla.firefox dev.zed.Zed io.github.ungoogled_software.ungoogled_chromium

echo O | pacman -Rns epiphany

echo "Souhaitez-vous que nous installions pour vous les services Île-de-France, permettant la connexion au Wi-Fi du lycée, l'accès facilité à MonLycée.net, etc."
if confirm "Ceci est vivement recommandé si vous êtes encore au lycée. Notez que vous pourrez les désinstaller à tout moment sans réitérer le processus d'installation."; then
        echo "Chargement de l'installateur..."
        ./idf_services/installer.sh
fi

echo "Ajout de la touche finale..."
mkdir ~/.icons/

cp packages/dash-to-dock@micxgx.gmail.com ~/.local/share/gnome-shell/extensions
gnome-extensions enable dash-to-dock@micxgx.gmail.com

rm ~/.var/app/dev.zed.Zed/config/zed/settings.json

mkdir ~/.local/share/icons/update

cp assets/conf/zed/zed.json ~/.var/app/dev.zed.Zed/config/zed/settings.json
cp assets/icons/update.png ~/.local/share/icons/update/icon.png
cp assets/conf/Update.desktop ~/.local/share/applications

systemctl enable bluetooth
systemctl enable gdm
systemctl enable upower
systemctl enable pipewire pipewire-pulse
rm -rf /etc/pacman.d/mirrorlist.bak
exit
