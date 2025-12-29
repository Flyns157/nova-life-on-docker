#!/bin/bash
set -e

# Variables d'environnement avec valeurs par défaut
SERVER_NAME="${SERVER_NAME:-MonServeur}"
SERVER_PORT="${SERVER_PORT:-7777}"
PING_PORT="${PING_PORT:-7778}"
STEAM_PORT="${STEAM_PORT:-27016}"
QUERY_PORT="${QUERY_PORT:-27015}"

# Répertoires
SERVER_DIR="/home/novalife/nova-life_server"
SERVERS_DIR="${SERVER_DIR}/Servers"

echo "=========================================="
echo "Démarrage du serveur Nova Life"
echo "=========================================="
echo "Nom du serveur: ${SERVER_NAME}"
echo "Port serveur: ${SERVER_PORT}"
echo "Port ping: ${PING_PORT}"
echo "Port Steam: ${STEAM_PORT}"
echo "Port Query: ${QUERY_PORT}"
echo "=========================================="

# Vérification de l'existence du dossier serveur
if [ ! -d "${SERVERS_DIR}/${SERVER_NAME}" ]; then
    echo "ERREUR: Le dossier du serveur '${SERVER_NAME}' n'existe pas dans ${SERVERS_DIR}"
    echo "Veuillez placer les fichiers de votre serveur dans le volume monté."
    echo "Création d'un dossier exemple..."
    mkdir -p "${SERVERS_DIR}/${SERVER_NAME}"
    echo "Note: Le serveur ne démarrera pas correctement sans les fichiers de configuration."
fi

# Création du dossier de logs si nécessaire
mkdir -p "${SERVER_DIR}/logs"

# Démarrage du serveur
cd "${SERVER_DIR}"

echo "Lancement du serveur Nova Life..."
exec ./nova-life.x86_64 \
    -batchmode \
    -nographics \
    -startServer "${SERVER_NAME}" \
    -logFile "${SERVER_DIR}/logs/server.log"