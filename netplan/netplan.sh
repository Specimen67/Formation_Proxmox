echo "Choisissez le domaine à configurer :"
select domaine in ocean mountain nassan; do
    if [[ -n "$domaine" ]]; then
        echo "Domaine sélectionné : $domaine"
        break
    else
        echo "Choix invalide. Veuillez sélectionner un domaine valide."
    fi
done

cp 00-installer-config.yaml.$domaine /etc/netplan/00-installer-config.yaml
netplan apply

echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -o $(ip -o link show | awk -F': ' 'NR==2 {print $2}') -j MASQUERADE
apt install iptables-persistent -y
