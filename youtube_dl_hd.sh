#!/bin/bash

set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR


# Chemin vers le dossier de logs
log_dir="/home/delfred/mes_programmes/mes_logs"
log_file="$log_dir/mes_logs_$(date '+%Y-%m-%d').log"

# Vérifier si le dossier de logs existe
if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

# ─── YOUTUBE VIDEO DOWNLOADER HIGH QUALITY ───

# Demander l'URL de la vidéo
read -p "🎥 Entre l'URL YouTube de la vidéo : " video_url

# Dossier de destination
download_dir="$HOME/Downloads/videos"
mkdir -p "$download_dir"

# Télécharger la meilleure vidéo et le meilleur audio disponibles
yt-dlp \
  -f "bv*+ba/best" \
  -o "$download_dir/%(title)s.%(ext)s" \
  --merge-output-format mp4 \
  "$video_url"

log ""
log ""
log "✅ Téléchargement terminé !"
log "📁 Fichier disponible dans : $download_dir"
log
ls "$download_dir"