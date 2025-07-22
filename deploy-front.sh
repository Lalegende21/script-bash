#!/bin/sh

echo "Deploiement du front imc"

CVS_URL=https://gitlab.com
CVS_GROUP=bootcamp-devops7241002/projet
CVS_PROJECT=front-imc

#wget https://gitlab.com/bootcamp-devops7241002/projet/front-imc/-/archive/main/front-imc-main.zip

# Suppression des anciens fichiers s'ils existent
if [ -f $CVS_PROJECT-main.zip ]; then
    rm $CVS_PROJECT-main.zip
fi

# Url du projet a telecharger
wget $CVS_URL/$CVS_GROUP/$CVS_PROJECT/-/archive/main/$CVS_PROJECT-main.zip

# Dezipper le projet
unzip -o $CVS_PROJECT-main.zip -d $CVS_PROJECT

# Installer les dependances et generer le build
cd $CVS_PROJECT/$CVS_PROJECT-main && npm install && npm run build

# creation du lien symbolique
ln -s /etc/nginx/sites-available/dt.imc.chillo.fr.conf /etc/nginx/sites-enabled/dt.imc.chillo.fr