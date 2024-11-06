#!/bin/bash

sites_enabled_dir="/etc/nginx/sites-enabled"
sites_available_dir="/etc/nginx/sites-available"
source_file="pve1"
destination_file_pve2="pve2"
destination_file_pve3="pve3"

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
