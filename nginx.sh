#!/bin/bash

source_file="/etc/nginx/sites-available/pve1"
destination_file_pve2="/etc/nginx/sites-available/pve2"
destination_file_pve3="/etc/nginx/sites-available/pve3"
enabled_dir="/etc/nginx/sites-enabled"

if [ ! -f "$source_file" ]; then
    echo "Le fichier source $source_file n'existe pas."
    exit 1
fi

cp "$source_file" "$destination_file_pve2"
sed -i 's/pve1/pve2/g' "$destination_file_pve2"

cp "$source_file" "$destination_file_pve3"
sed -i 's/pve1/pve3/g' "$destination_file_pve3"

ln -sf "$destination_file_pve2" "$enabled_dir/pve2"
ln -sf "$destination_file_pve3" "$enabled_dir/pve3"

systemctl restart nginx

if systemctl is-active --quiet nginx; then
    echo "Nginx a redémarré avec succès."
else
    echo "Erreur lors du redémarrage de Nginx."
    exit 1
fi

echo "Les fichiers pve2 et pve3 ont été créés et activés avec succès."
