#!/bin/sh

for PROJ_NAME in $@

do

git init --bare /var/repos/${PROJ_NAME}

git clone /var/repos/${PROJ_NAME} /var/www/html/${PROJ_NAME}

cp $HOME/post-update /var/repos/${PROJ_NAME}/hooks/

sed -i -e "s/^PROJ_NAME=/PROJ_NAME=${PROJ_NAME}/" /var/repos/${PROJ_NAME}/hooks/post-update

done

