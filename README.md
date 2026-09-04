# UbuntuConf
# UbuntuConf

Configuration automatisée pour client Ubuntu au sein du réseau local `192.168.17.x`.

## Description

Ce projet permet de configurer rapidement un poste client Ubuntu (comme la machine `Bmax-9`) pour l'intégrer au réseau domestique. Il gère l'accès aux partages réseau, la configuration DNS et l'installation des outils multimédias de base.

Le script `ConfUbuntuClient.sh` automatise les actions suivantes :
* **Montages réseau (NFS / AutoFS)** : Configuration des partages automatiques dans `/srv/` (`photos`, `musique`, `video`, `admin`, `pierre`).
* **Réseau & DNS** : Configuration robuste du DNS via `resolvconf` intégrant le serveur local, la Freebox Pop et un DNS de secours.
* **Droits utilisateurs** : Création du groupe local `villebon` (GID 1001) et affectation de l'utilisateur `pierre`.
* **Raccourcis** : Création automatique des liens symboliques vers les partages réseau directement sur le Bureau de l'utilisateur.
* **Logiciels** : Installation automatisée du lecteur multimédia VLC.

## Structure du projet

```text
UbuntuConf/
├── ConfUbuntuClient.sh   # Script principal de configuration
├── README.md             # Ce fichier d'instructions
└── etc/
    ├── auto.master       # Configuration racine pour AutoFS
    └── auto.srv          # Modèle de configuration des partages NFS
```

## Utilisation

### 1. Cloner le dépôt
Utilisez votre jeton d'accès personnel (Token) GitHub pour cloner le projet :
```bash
git clone https://github.com/billoven/UbuntuConf/
cd UbuntuConf
```

### 2. Ajuster l'adresse IP du serveur
Ouvrez le script `ConfUbuntuClient.sh` avec votre éditeur de texte et modifiez la variable `SERVER_IP` tout en haut si l'adresse de votre serveur de stockage a changé (par défaut : `192.168.17.10`).

### 3. Rendre le script exécutable
Donnez les droits d'exécution au script :
```bash
chmod +x ConfUbuntuClient.sh
```

### 4. Lancer la configuration
Exécutez le script avec vos privilèges utilisateur (le script demandera votre mot de passe `sudo`) :
```bash
./ConfUbuntuClient.sh
```

---
*Note : La Freebox Pop présente sur le réseau est automatiquement détectée par le script pour servir de relais DNS secondaire.*

