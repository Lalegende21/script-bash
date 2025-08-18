#!/bin/bash

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

echo ""
echo ""
echo "✅ Téléchargement terminé !"
echo "📁 Fichier disponible dans : $download_dir"
echo
ls "$download_dir"