#!/bin/bash

set -euo pipefail

# Repertoire parent
PROJECT_HOME="/opt/delfred-tene/imc"

# Les differentes commandes à executer
commandToCreateFolder="mkdir"
commandToRemoveFolder="rm -rf"
commandToListFolder="$PROJECT_HOME/ls -al"

if [[ "$#" -eq 0 && "$#" -lt 3 ]]; then
    echo "Aucun argument fourni"
    echo "Usage: $0 [nom_repertoire1] [nom_repertoire2] [nom_repertoire3]";
    exit 1
fi

# Boucle pour vérifier si les répertoires existent
for item in "$@"; do
    if [[ -e "$item" ]]; then
        echo "Le répertoire $item existe"
        $commandToRemoveFolder "$item"
        echo "Le répertoire $item a été supprimé"
        echo ""
    else
        echo "Le répertoire $item n'existe pas"
    fi
    $commandToCreateFolder "$item"
    echo "Le répertoire $item a été créé"
    echo ""
done

# Lister le contenu
$commandToListFolder

# Message de fin propre
exit 0