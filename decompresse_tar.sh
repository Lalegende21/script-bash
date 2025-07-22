#!/bin/bash

# Gestion des erreurs
set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR

# Chemin vers le dossier contenant les fichiers
FOLDER_PATH="/home/delfred/mes_programmes/projets/devops/scripts"

# Chemin vers le dossier de logs
log_dir="/home/delfred/mes_programmes/mes_logs"
log_file="$log_dir/mes_logs.log"

# Vérifier si le dossier de logs existe
if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}


# Verifier si le dossier contenant les fichiers existe
if [[ ! -d "$FOLDER_PATH" ]]; then
    log "Le dossier $FOLDER_PATH n'a pas ete fourni en argument.";
    mkdir "$FOLDER_PATH";
    log "Le dossier $FOLDER_PATH a ete cree.";
fi

# Verifier si un argument a ete fourni
if [[ "$#" -lt 1 ]]; then
    log "Aucun argument fourni";
    log "Usage: $0 [chemin_du_tar]";
    exit 1;
fi

# Verifier si l'argument fourni est un fichier
if [[ ! -f "$1" ]]; then
    log "Le fichier $1 n'existe pas."
    exit 1
fi


# Verifier si le fichier fourni est un tar
if [[ "$1" != *.tar ]]; then
    log "Le fichier fourni n'est pas un tar";
    log "Usage: $0 [chemin_du_tar]";
    exit 1;
fi

# Decompresser le tar
tar -xvf "$1" -C "$FOLDER_PATH";
log "Le fichier $1 a ete decompresser";

# Message de fin propre
exit 0