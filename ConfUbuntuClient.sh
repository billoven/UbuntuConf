#!/usr/bin/env bash

# Arrête le script en cas d'erreur
set -e

# ==============================================================================
# CONFIGURATION : Définissez uniquement l'IP de votre serveur local ici
# ==============================================================================
SERVER_IP="192.168.17.30"
# ==============================================================================

echo "=== Début de la configuration d'Ubuntu ==="
echo " --> Serveur ciblé : $SERVER_IP"

# Détection automatique de l'IP de la Freebox Pop (Passerelle par défaut)
FREEBOX_IP=$(ip route | grep default | awk '{print $3}' | head -n 1)
echo " --> Freebox Pop détectée à l'adresse : $FREEBOX_IP"

# 1. Mise à jour des dépôts
echo " --> Mise à jour de la liste des paquets..."
sudo apt update

# 2. Installation de NFS et AutoFS
echo " --> Installation de NFS et AutoFS..."
sudo apt install -y nfs-common autofs

# 3. Configuration d'AutoFS
echo " --> Copie des fichiers AutoFS..."
sudo cp -fp etc/auto.master /etc/
sudo cp -fp etc/auto.srv /etc/

# Remplacement dynamique de l'IP du serveur dans le fichier final /etc/auto.srv
echo " --> Configuration de l'IP du serveur dans AutoFS..."
sudo sed -i "s/192.168.17.10/$SERVER_IP/g" /etc/auto.srv

# Application des bonnes permissions
sudo chmod 644 /etc/auto.master /etc/auto.srv
sudo chown root:root /etc/auto.master /etc/auto.srv

echo " --> Redémarrage du service AutoFS..."
sudo systemctl restart autofs
sudo systemctl enable autofs

# 4. Configuration DNS via resolvconf
echo " --> Installation de resolvconf..."
sudo apt install -y resolvconf

echo " --> Génération dynamique de la configuration DNS..."
# On prépare le contenu du fichier DNS directement avec les bonnes IPs
sudo bash -c "cat << EOF > /etc/resolvconf/resolv.conf.d/base
### BEGIN INFO
# Configuration DNS automatisée pour réseau 192.168.17.x
### END INFO

# 1. Votre serveur local
nameserver $SERVER_IP

# 2. Votre Freebox Pop (Passerelle DNS automatique)
nameserver $FREEBOX_IP

# 3. DNS public de secours (Cloudflare)
nameserver 1.1.1.1

domain villebon.net
EOF"

sudo chmod 644 /etc/resolvconf/resolv.conf.d/base
sudo chown root:root /etc/resolvconf/resolv.conf.d/base

# Application des changements DNS
sudo systemctl enable --now resolvconf
sudo resolvconf -u

# 5. Gestion des groupes et utilisateurs
echo " --> Création du groupe 'villebon' (GID 1001)..."
sudo groupadd -g 1001 -f villebon

echo " --> Ajout de l'utilisateur 'pierre' au groupe 'villebon'..."
sudo usermod -aG villebon pierre

# 6. Test du montage automatique
echo " --> Test de l'automount sur la ressource 'photos'..."
sleep 2
if ls /srv/photos > /dev/null 2>&1; then
    echo "     [OK] Le point de montage automatique fonctionne."
else
    echo "     [ATTENTION] Le montage /srv/photos n'a pas répondu. Vérifiez l'IP ou le serveur NFS."
fi

# 7. Création des liens symboliques sur le Bureau
echo " --> Création des liens symboliques sur le Bureau de pierre..."
DESKTOP_DIR="/home/pierre/Bureau"
mkdir -p "$DESKTOP_DIR"

ln -sf /srv/pierre "$DESKTOP_DIR/"
ln -sf /srv/photos "$DESKTOP_DIR/"
ln -sf /srv/musique "$DESKTOP_DIR/"
ln -sf /srv/video "$DESKTOP_DIR/"
ln -sf /srv/admin "$DESKTOP_DIR/"

# Correction des permissions des liens pour l'utilisateur pierre
sudo chown -h pierre:pierre "$DESKTOP_DIR"/*

# 8. Installation des applications multimédias
echo " --> Installation de VLC..."
sudo apt install -y vlc

echo "=== Configuration terminée avec succès ! ==="

