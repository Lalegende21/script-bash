#!/bin/bash

set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR

# Chemin vers le dossier de logs
log_dir="/home/delfred/mes_programmes/mes_logs/create_user_logs"
log_file="$log_dir/mes_logs_$(date '+%Y-%m-%d').log"

# Vérifier si le dossier de logs existe
if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

# Vérifier si l'utilisateur est root
if [[ $EUID -ne 0 ]]; then
    log "Ce script doit être exécuté en root." >&2
    exit 1
fi

log "Entrez le nom de l'utilisateur:"
read -r username
log "Nom de l'utilisateur fourni: $username"

# Nettoyer l'entree de l'utilisateur
realUsername=$(echo "$username" | sed -r 's/[^a-zA-Z0-9._-]//g')

# Verifier si le nom d'utilisateur est valide
if [[ -z "$realUsername" ]]; then
    log "Nom d'utilisateur invalide après nettoyage."
    exit 1
fi

log "Nom de l'utilisateur nettoye: $realUsername"

# Verifier que l'utilisateur n'existe pas deja
if id "$realUsername" &> /dev/null; then
    log "L'utilisateur $realUsername existe deja."
    exit 1
fi

# Creation de l'utilisateur avec son dossier parent
useradd -m "$realUsername"

# Fonction pour générer un mot de passe
generate_password() {
    # Génère un mot de passe de 12 caractères, mélange lettres, chiffres, symboles
    # Filtrage pour éviter les caractères spéciaux qui posent problème
    openssl rand -base64 12 | tr -dc 'A-Za-z0-9@#$%&*' | head -c 12
}

# Demander si on veut attribuer un mot de passe
while true; do
    log "Voulez-vous attribuer un mot de passe ? (o->oui/n->non/g->generation automatique)"
    read -r choice
    log "Choix de l'utilisateur: $choice"

    case "$choice" in
        ([oO])
            passwd "$realUsername"
            log "Le mot de passe a été attribué."
            break
            ;;
        ([nN])
            log "Le mot de passe n'a pas été attribué."
            break
            ;;
        ([gG])
            pwd=$(generate_password)
            echo "$realUsername:$pwd" | chpasswd
            log "Mot de passe généré automatiquement : $pwd"
            break
            ;;
        (*)
            log "Choix invalide, veuillez répondre par o, n ou g."
            ;;
    esac
done


# Afficher les infos de l'utilisateur
log "Informations de l'utilisateur:"
id "$realUsername"

log "Utilisateur $realUsername créé avec succès."

exit 0