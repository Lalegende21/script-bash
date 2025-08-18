#!/bin/bash

# ─── YOUTUBE VIDEO DOWNLOADER HIGH QUALITY ───

# Demander l'URL de la vidéo
read -p "🎥 Entre l'URL YouTube de la playlist : " playlist_url

# Dossier de destination
download_dir="$HOME/Downloads/videos"
mkdir -p "$download_dir"

# Télécharger la meilleure vidéo et le meilleur audio disponibles
yt-dlp \
    -f "bv*+ba/b" \
    -o "~/Vidéos/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" \
    --merge-output-format mp4 \
    "$playlist_url"

echo ""
echo ""
echo "✅ Téléchargement terminé !"
echo "📁 Fichier disponible dans : $download_dir"