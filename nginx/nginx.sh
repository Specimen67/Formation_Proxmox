#!/bin/bash

sites_enabled_dir="/etc/nginx/sites-enabled"
sites_available_dir="/etc/nginx/sites-available"
source_file="pve1"
destination_file_pve2="pve2"
destination_file_pve3="pve3"
ssl_dir="/etc/nginx/ssl"
cert_file="$ssl_dir/ocean.$prenom.lan.crt"
key_file="$ssl_dir/ocean.$prenom.lan.key"

if [ -d "$sites_enabled_dir" ]; then
    rm -rf "$sites_enabled_dir"/*
    echo "Contenu de $sites_enabled_dir supprimé."
else
    echo "Le dossier $sites_enabled_dir n'existe pas."
fi

if [ -d "$sites_available_dir" ]; then
    rm -rf "$sites_available_dir"/*
    echo "Contenu de $sites_available_dir supprimé."
else
    echo "Le dossier $sites_available_dir n'existe pas."
fi

if [ -f "$source_file" ]; then
    # Créer les fichiers pve2 et pve3 en dupliquant pve1
    cp "$source_file" "$destination_file_pve2"
    cp "$source_file" "$destination_file_pve3"
    
    # Remplacer "pve1" par "pve2" dans le fichier pve2
    sed -i 's/pve1/pve2/g' "$destination_file_pve2"
    sed -i 's/pve-1/pve-2/g' "$destination_file_pve2"
    echo "Fichier pve2 créé et modifié."

    # Remplacer "pve1" par "pve3" dans le fichier pve3
    sed -i 's/pve1/pve3/g' "$destination_file_pve3"
    sed -i 's/pve-1/pve-3/g' "$destination_file_pve3"
    echo "Fichier pve3 créé et modifié."
else
    echo "Le fichier source pve1 n'existe pas dans le répertoire actuel."
fi

read -p "Entrez votre prénom pour l'inclure dans le nom de domaine : " prenom

sed -i "s/stagiaire/$prenom/g" "$source_file"
sed -i "s/stagiaire/$prenom/g" "$destination_file_pve2"
sed -i "s/stagiaire/$prenom/g" "$destination_file_pve3"

echo "Le prénom $prenom a été ajouté dans les noms de domaine des fichiers pve1, pve2 et pve3."
rm -rf /etc/nginx/ssl
mkdir -p "$ssl_dir"

openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -keyout "$key_file" \
    -out "$cert_file" \
    -subj "/C=FR/ST=formation/L=proxmox/O=Dawan/OU=IT/CN=ocean.$prenom.lan"

echo "Certificats SSL générés :"
echo " - Certificat : $cert_file"
echo " - Clé privée : $key_file"

cp "$source_file" "$sites_available_dir/"
cp "$destination_file_pve2" "$sites_available_dir/"
cp "$destination_file_pve3" "$sites_available_dir/"
echo "Fichiers pve1, pve2 et pve3 copiés dans $sites_available_dir."

ln -s "$sites_available_dir/pve1" "$sites_enabled_dir/pve1"
ln -s "$sites_available_dir/pve2" "$sites_enabled_dir/pve2"
ln -s "$sites_available_dir/pve3" "$sites_enabled_dir/pve3"
echo "Sites pve1, pve2 et pve3 activés."

echo "172.16.1.1 pve1.ocean.$prenom.lan" | sudo tee -a /etc/hosts
echo "172.16.1.1 pve2.ocean.$prenom.lan" | sudo tee -a /etc/hosts
echo "172.16.1.1 pve3.ocean.$prenom.lan" | sudo tee -a /etc/hosts
echo "172.16.1.10 pve-1.ocean.$prenom.lan" | sudo tee -a /etc/hosts
echo "172.16.1.11 pve-2.ocean.$prenom.lan" | sudo tee -a /etc/hosts
echo "172.16.1.12 pve-3.ocean.$prenom.lan" | sudo tee -a /etc/hosts
echo "Entrées ajoutées dans /etc/hosts."

sudo systemctl restart nginx
echo "Nginx redémarré avec succès."