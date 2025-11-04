#! /bin/bash

confirm() {
    read -rp "$* [O/n] " ans
    [[ "${ans,,}" == "O" ]]
}

echo "Bienvenue"
if ! confirm "Souhaitez-vous vraiment désinstaller les services Île-de-France ?"; then
    echo "L'installation a été annulée par l'utilisateur"
    exit 1
fi

echo "Désinstallation de MonLycée.net"
rm -rf ~/.local/share/icons/monlycee
rm -f ~/.local/share/applications/MonLycee.desktop
echo "Désinstallation de la messagerie MonLycée.net"
rm -rf ~/.var/app/org.gnome.Geary/config/geary/account_01/
echo "Suppression du certificat Wi-Fi Île-de-France"
#certificat wifi
echo "Chargement des services..."

echo "Désinstallation des services IDF terminée ! Votre ordinateur va redémarrer."
sudo systemctl reboot
