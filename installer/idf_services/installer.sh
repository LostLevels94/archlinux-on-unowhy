#! /bin/bash

echo "INSTALLATEUR DES SERVICES IDF"
read -p "ID MonLycée (souvent prenom.nom ou prenom.nomX): " mlid
#read -sp "Mot de passe MonLycée: " mlpwd
mlmail="$mlid@monlycee.net"

mkdir ~/.local/share/icons/monlycee
cp assets/icons/monlycee.png ~/.local/share/icons/monlycee/icon.png
cp assets/conf/MonLycee.desktop ~/.local/share/applications

flatpak install org.gnome.Geary
cp assets/conf/geary.ini assets/conf/geary-c.ini
sed -i '' 's/madress_mlnet/mlid/g' "assets/conf/geary-c.ini"
cp assets/conf/geary-c.ini /home/lyceen/.var/app/org.gnome.Geary/config/geary/account_01/geary.ini

#certificat+mdp wifi lycée

mkdir ~/.local/share/idf
cp uninstaller.sh ~/.local/share/idf
