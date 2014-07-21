#!/bin/sh

PROJ_NAME=$1

mkdir /var/repos/${PROJ_NAME}
cd /var/repos/${PROJ_NAME} && git --bare init
cd /var/www/html && git clone /var/repos/${PROJ_NAME}

