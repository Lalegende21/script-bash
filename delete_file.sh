#!/bin/bash
set -euo pipefail

# Demander a l'utilisateur de fournir un nom de fichier
echo "Entrez le nom du fichier a supprimer:";
read -r filename;

# Nettoyer l'entree de l'utilisateur
cleaned_filename=$(echo "$filename" | sed -r 's/[^a-zA-Z0-9._-]//g');

# Validation de l'entree de l'utilisateur
if [[ -e "$cleaned_filename" ]]; then
    echo "Le fichier $cleaned_filename existe.";
else
    echo "Le fichier $cleaned_filename n'existe pas.";
fi

if [[ ! -w "$cleaned_filename" ]]; then
    echo "Erreur : vous n'avez pas les droits d'écriture sur '$cleaned_filename'."
    exit 1
fi

# Supprimer le fichier
if ! /bin/rm -- "$cleaned_filename"; then
    echo "Erreur lors de la suppression du fichier $cleaned_filename.";
    exit 1
fi

#Confirmation de la suppression
echo "Le fichier $cleaned_filename a ete supprime.";

# Message de fin propre
exit 0