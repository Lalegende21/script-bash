#!/bin/bash

set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR

# Chemin vers le dossier de logs
log_dir="/home/delfred/mes_programmes/mes_logs/maj_logs"
log_file="$log_dir/mes_logs_$(date '+%Y-%m-%d').log"

# Vérifier si le dossier de logs existe
if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

# Fonction pour attendre que dpkg/apt soient libres
wait_for_apt() {
    log "Vérification de la disponibilité du gestionnaire de paquets"
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
        log "Un autre processus utilise apt/dpkg, attente de 15 secondes..."
        sleep 15
    done
}

create_space_after_execution() {
    log ""
    log ""
    log ""
    log ""
}

command -v apt-get >/dev/null 2>&1 || { echo "apt-get non disponible"; exit 1; }

log "Debut du nettoyage du systeme"

log "Nettoyage du cache des paquets installes"
apt-get clean 2>&1 | tee -a "$log_file"

# Vérifie si apt/dpkg sont libres
wait_for_apt
create_space_after_execution

log "Suppression des paquets inutiles"
apt-get -y autoremove 2>&1 | tee -a "$log_file"

create_space_after_execution

log "Debut de la mise a jour"

log "Mise a jour de la liste des paquets disponibles"
apt-get update 2>&1 | tee -a "$log_file"

create_space_after_execution

log "Mise a jour de tous les paquets installes"
apt-get -y upgrade 2>&1 | tee -a "$log_file"

log "Mise a jour terminee avec succes"

# Message de fin propre
exit 0