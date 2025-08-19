#!/bin/bash

set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR

# Chemin vers le dossier de logs
log_file="/home/delfred/mes_programmes/mes_logs/mes_logs_$(date '+%Y-%m-%d').log"
log() {
    echo "$(date '+%y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

# Repertoire parent
PROJECT_HOME="/opt/delfred-tene/imc"

# Les differentes commandes à executer
commandToCreateFolder="mkdir"
commandToRemoveFolder="rm -rf"
commandToListFolder="$PROJECT_HOME/ls -al"

if [[ "$#" -eq 0 && "$#" -lt 3 ]]; then
    log "Aucun argument fourni"
    log "Usage: $0 [nom_repertoire1] [nom_repertoire2] [nom_repertoire3]";
    exit 1
fi

# Boucle pour vérifier si les répertoires existent
for item in "$@"; do
    if [[ -e "$item" ]]; then
        echo "Le répertoire $item existe"
        mkdir "$item"+"_"+"$(date '+%Y-%m-%d')"
        log "Le répertoire $item+"_"+$(date '+%Y-%m-%d') a été cree en tant que backup"
        $commandToRemoveFolder "$item"
        log "Le répertoire $item a été supprimé"
        log ""
    else
        log "Le répertoire $item n'existe pas"
    fi
    $commandToCreateFolder "$item"
    log "Le répertoire $item a été créé"
    log ""
done

# Lister le contenu
$commandToListFolder

# Message de fin propre
exit 0