#!/bin/sh

for PROJ_NAME in $@
do
git init --bare /var/repos/${PROJ_NAME}
git clone /var/repos/${PROJ_NAME} /var/www/html/${PROJ_NAME}
ln -s ${HOME}/post-update /var/repos/${PROJ_NAME}/hooks/
done

