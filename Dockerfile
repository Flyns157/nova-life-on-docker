FROM ubuntu:22.04

# Éviter les prompts interactifs
ENV DEBIAN_FRONTEND=noninteractive

# Variables d'environnement
ENV USER=novalife
ENV HOME=/home/${USER}
ENV STEAM_DIR=${HOME}/steam_ds
ENV SERVER_DIR=${HOME}/nova-life_server
ENV SERVER_NAME="MonServeur"

# Installation des dépendances
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    lib32gcc-s1 \
    wget \
    tar \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur
RUN useradd -m -s /bin/bash ${USER}

# Changement vers l'utilisateur
USER ${USER}
WORKDIR ${HOME}

# Installation de SteamCMD
RUN mkdir -p ${STEAM_DIR} && \
    cd ${STEAM_DIR} && \
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Installation du serveur Nova-Life via SteamCMD
RUN ${STEAM_DIR}/steamcmd.sh \
    +login anonymous \
    +force_install_dir ${SERVER_DIR} \
    +app_update 1665030 validate \
    +quit

# Création du dossier Servers
RUN mkdir -p ${SERVER_DIR}/Servers

# Configuration du SDK Steam
RUN mkdir -p ${HOME}/.steam/sdk64 && \
    cp ${SERVER_DIR}/linux64/steamclient.so ${HOME}/.steam/sdk64/

# Définir le répertoire de travail
WORKDIR ${SERVER_DIR}

# Exposition des ports
EXPOSE 7777/udp 7778/udp 27015/udp 27016/udp

# Script de démarrage
COPY --chown=${USER}:${USER} entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]