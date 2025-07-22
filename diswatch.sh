#!/bin/bash

set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR


# Chemin vers le dossier de logs
log_dir="/home/delfred/mes_programmes/mes_logs/diswatch_logs"
log_file="$log_dir/mes_logs_$(date '+%Y-%m-%d').log"

# Vérifier si le dossier de logs existe
if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

log "Debut du scan du disque"

#  récupérer le pourcentage d'utilisation du disque de la partition racine (/), sans le symbole %.
usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

# Dossier du msmtp
msmtp_dir="/home/delfred/.msmtprc"

# Adresse de l'expediteur et du destinataire
from="delfredtene17@gmail.com"
destinataire="delfredtene17@gmail.com"

if [[ "$usage" -gt 80 ]]; then
    log "Alerte: partition / utilisée à ${usage}%"

    email_content=$(cat <<EOF
        From: $from
        To: $destinataire
        Subject: Alerte espace disque
        Date: $(date -R)
        Content-Type: text/plain; charset=utf-8

        Bonjour,

        La partition racine (/) est utilisée à ${usage}% ce qui est supérieur au seuil critique de 80%.

        Merci de vérifier rapidement.

        Cordialement,
        Ton script de surveillance disque
EOF
)

    # Envoyer une alerte par email
    if echo "$email_content" | msmtp --file=$msmtp_dir -a gmail "$destinataire"; then
        log "Email envoyé avec succès."
        # Ajouter le contenu du msmtp.log dans ton log principal
        if [[ -f ~/.msmtp.log ]]; then
            log "Contenu du msmtp.log :"
            tail -n 20 ~/.msmtp.log | tee -a "$log_file"
        else
            log "Aucun fichier ~/.msmtp.log trouvé."
        fi
    else
        log "Erreur lors de l'envoi de l'email."
        
        if [[ -f ~/.msmtp.log ]]; then
            log "Contenu du msmtp.log :"
            tail -n 20 ~/.msmtp.log | tee -a "$log_file"
        else
            log "Aucun fichier ~/.msmtp.log trouvé."
        fi
    fi
else
    log "Espace disque OK: utilisation à ${usage}%"

        email_content=$(cat <<EOF
        From: $from
        To: $destinataire
        Subject: Bonne utilisation de l'espace disque
        Date: $(date -R)
        Content-Type: text/plain; charset=utf-8

        Bonjour,

        La partition racine (/) est utilisée à ${usage}% ce qui est inferieur au seuil critique de 80%.

        Merci de continuer de prendre soin de votre disque.

        Cordialement,
        Ton script de surveillance disque
EOF
)

    # Envoyer une alerte par email
    if echo "$email_content" | msmtp --file=$msmtp_dir -a gmail "$destinataire"; then
        log "Email envoyé avec succès."
    fi
fi
