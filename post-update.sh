#!/bin/sh
git update-server-info
cd /var/www/html && sudo git –git-dir=.git pull
