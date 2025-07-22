#!/bin/sh

echo "Deploiement du front gestmarter"

CVS_URL=https://github.com
CVS_NAME=Lalegende21
CVS_PROJECT=getsapp
CVS_PROJECT_NAME=25eafac80392c2900580b345999a3b5c7375daad

# wget https://github.com/Lalegende21/getsapp/archive/25eafac80392c2900580b345999a3b5c7375daad.zip

# Suppression des anciens fichiers s'ils existent
if [ -f $CVS_PROJECT_NAME.zip ]; then
    rm $CVS_PROJECT_NAME.zip
fi

wget $CVS_URL/$CVS_NAME/$CVS_PROJECT/archive/$CVS_PROJECT_NAME.zip

mv $CVS_PROJECT_NAME.zip $CVS_PROJECT-main.zip

# Dezipper le projet
unzip -o $CVS_PROJECT-main.zip -d $CVS_PROJECT

# Se deplacer dans le projet
cd $CVS_PROJECT/$CVS_PROJECT-$CVS_PROJECT_NAME

# Installer les dependances et generer le build
npm install --force && ng build --configuration=production

# creation du lien symbolique
ln -s /etc/nginx/sites-available/getsmarter.fr.conf /etc/nginx/sites-enabled/getsmarter.fr