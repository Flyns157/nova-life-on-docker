# Serveur Nova Life - Déploiement Docker

Ce projet permet de déployer facilement un serveur Nova Life en utilisant Docker et Docker Compose.

## 📋 Prérequis

- Docker (version 20.10 ou supérieure)
- Docker Compose (version 1.29 ou supérieure)
- Au minimum 4 Go de RAM disponible
- 10 Go d'espace disque libre

## 📁 Structure des fichiers

```
nova-life-docker/
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
├── server-data/          # Vos fichiers de serveur ici
│   └── MonServeur/       # Dossier de votre serveur
├── logs/                 # Logs générés automatiquement
└── steamcmd/             # Cache SteamCMD (généré automatiquement)
```

## 🚀 Installation

### 1. Cloner ou créer les fichiers

Créez un nouveau dossier et placez-y les fichiers `Dockerfile`, `docker-compose.yml` et `entrypoint.sh`.

### 2. Préparer vos fichiers de serveur

Créez le dossier `server-data` et placez-y votre dossier de serveur Nova Life (préalablement configuré sur Windows) :

```bash
mkdir -p server-data/MonServeur
```

Copiez les fichiers de votre serveur dans `server-data/MonServeur/`.

### 3. Configurer le nom du serveur

Éditez le fichier `docker-compose.yml` et modifiez la variable `SERVER_NAME` :

```yaml
environment:
  - SERVER_NAME=MonServeur  # Changez ici
```

### 4. Construire l'image Docker

```bash
docker-compose build
```

Cette étape peut prendre plusieurs minutes car elle télécharge et installe SteamCMD et le serveur Nova Life.

### 5. Démarrer le serveur

```bash
docker-compose up -d
```

## 📊 Gestion du serveur

### Voir les logs en temps réel

```bash
docker-compose logs -f
```

ou consultez le fichier : `logs/server.log`

### Arrêter le serveur

```bash
docker-compose down
```

### Redémarrer le serveur

```bash
docker-compose restart
```

### Mettre à jour le serveur Nova Life

```bash
# Arrêter le serveur
docker-compose down

# Reconstruire l'image (cela mettra à jour Nova Life)
docker-compose build --no-cache

# Redémarrer
docker-compose up -d
```

## 🔧 Configuration avancée

### Modifier les ports

Si vous souhaitez utiliser des ports différents, éditez le `docker-compose.yml` :

```yaml
ports:
  - "7777:7777/udp"  # Format: "PORT_HÔTE:PORT_CONTAINER/udp"
  - "7778:7778/udp"
  - "27015:27015/udp"
  - "27016:27016/udp"
```

### Limites de ressources

Ajustez les limites CPU et RAM dans le fichier `docker-compose.yml` selon vos besoins :

```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
```

## 🌐 Ports utilisés

| Port  | Protocole | Description        |
|-------|-----------|-------------------|
| 7777  | UDP       | Port du serveur   |
| 7778  | UDP       | Port de ping      |
| 27015 | UDP       | SteamQuery        |
| 27016 | UDP       | Steam             |

## 🐛 Dépannage

### Le serveur ne démarre pas

1. Vérifiez que vos fichiers de serveur sont bien dans `server-data/MonServeur/`
2. Vérifiez les logs : `docker-compose logs`
3. Assurez-vous que les ports ne sont pas déjà utilisés

### Impossible de se connecter au serveur

1. Vérifiez que les ports sont bien ouverts sur votre pare-feu
2. Vérifiez la configuration réseau de votre hébergeur
3. Testez la connectivité : `docker-compose exec nova-life pgrep -f nova-life`

### Le conteneur s'arrête immédiatement

Consultez les logs détaillés :
```bash
docker-compose logs nova-life
```

## 📝 Notes importantes

- Le premier démarrage peut prendre du temps (téléchargement du serveur)
- Les données du serveur sont persistées dans les volumes Docker
- Pensez à sauvegarder régulièrement le dossier `server-data/`

## 🔄 Sauvegarde et restauration

### Sauvegarder

```bash
tar -czf backup-novalife-$(date +%Y%m%d).tar.gz server-data/ logs/
```

### Restaurer

```bash
tar -xzf backup-novalife-YYYYMMDD.tar.gz
```

## 📚 Ressources

- [Documentation officielle Nova Life](https://sites.google.com/view/nova-life-wiki)
- [Documentation Docker](https://docs.docker.com/)

## 👤 Auteur

Basé sur la documentation officielle Nova Life par Islide - https://www.twitch.tv/islidetn