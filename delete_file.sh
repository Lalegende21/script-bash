#!/bin/bash
set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR

# Chemin vers le dossier de logs
log_file="/home/delfred/mes_programmes/mes_logs/mes_logs_$(date '+%Y-%m-%d').log"
log() {
    echo "$(date '%Y-%m-%d %H:%M:%S') - $1 " | tee -a "$log_file"
}

# Demander a l'utilisateur de fournir un nom de fichier
echo "Entrez le nom du fichier a supprimer:";
read -r filename;

# Nettoyer l'entree de l'utilisateur
cleaned_filename=$(echo "$filename" | sed -r 's/[^a-zA-Z0-9._-]//g');

# Validation de l'entree de l'utilisateur
if [[ -e "$cleaned_filename" ]]; then
    log "Le fichier $cleaned_filename existe.";
else
    log "Le fichier $cleaned_filename n'existe pas.";
fi

if [[ ! -w "$cleaned_filename" ]]; then
    log "Erreur : vous n'avez pas les droits d'écriture sur '$cleaned_filename'."
    exit 1
fi

# Supprimer le fichier
if ! /bin/rm -- "$cleaned_filename"; then
    log "Erreur lors de la suppression du fichier $cleaned_filename.";
    exit 1
fi

#Confirmation de la suppression
log "Le fichier $cleaned_filename a ete supprime.";

# Message de fin propre
exit 0