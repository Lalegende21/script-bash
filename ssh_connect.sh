#!/bin/bash

set -euo pipefail
trap 'echo "Erreur à la ligne $LINENO"; exit 1' ERR

# Verifie si deux arguments ont ete fournis
if [[ "$#" -ne 2 ]]; then
    echo "2 arguments attendus, le port et le host(nom de domaine)"
    echo "Usage: $0 [port] [host]"
    exit 1
fi

# Connexion au serveur SSH
port="$1"
host="$2"

# Verfie si le port est un entier
if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    echo "Erreur : le port doit être un nombre entier"
    exit 1
fi

# Verifie si le port est dans la plage autorisée
if (( port < 1 || port > 65535 )); then
    echo "Erreur : le port doit être compris entre 1 et 65535"
    exit 1
fi

# Verifier que l'hote est non vide
if [[ -z "$host" ]]; then
    echo "Erreur : le nom d’hôte ne peut pas être vide"
    exit 1
fi

# Verifier que le nom d'hote est non vide
if [[ -z "$host" ]]; then
    echo "Erreur : le nom d’hôte ne peut pas être vide"
    exit 1
fi

# Verifier la connectivite du serveur SSH
if ! ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
    echo "Attention : l’hôte $host est injoignable (ping échoué)"
    # Tu peux choisir de continuer quand même
    # exit 1
fi

echo "Connexion à $host sur le port $port..."
ssh -p "$port" "$host"