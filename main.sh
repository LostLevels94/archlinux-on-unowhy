#! /bin/bash
DISK=“/dev/mmcblk0”

confirm() {
    read -rp "$* [O/n] " ans
    [[ "${ans,,}" == "O" ]]
}

echo "Bienvenue"
if ! confirm "AVERTISSEMENT : Ce programme va effacer votre disque pour y installer UNOTHER. Continuer ?"; then
        echo "Installation annulée. Pour recommencer, tapez unoinstall."
        exit 1
fi

sfdisk --delete "$DISK"
sfdisk "$DISK" <<EOF
label: gpt
size=+512M, type=EF00, name="EFI System Partition"
;
EOF
sfdisk -a "$DISK" <<EOF
size=+, type=8300, name="Root"
EOF

mkfs.fat -F32 "/dev/mmcblk0p1"
mkfs.btrfs -L "UNOWHY_y13" "/dev/mmcblk0p2"

echo "Configuration du système..."
echo Y | pacman -Syy && echo Y | pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "FR" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
mount /dev/mmcblk0p2 /mnt
pacstrap /mnt base linux linux-firmware micro
genfstab -U /mnt >> /mnt/etc/fstab

mkdir /mnt/home/root/
cp installer /mnt/home/root/
arch-chroot /mnt ./home/root/installer/install_unother.sh

echo "Installation de UNOTHER terminée ! Votre ordinateur va redémarrer."
systemctl reboot
