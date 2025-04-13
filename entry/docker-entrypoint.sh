#!/bin/sh

# Start PHP-FPM im Hintergrund
php-fpm -D

envsubst '$WEBROOT' < /etc/nginx/conf.d/default.conf.tmpl > /etc/nginx/conf.d/default.conf
# Starte nginx im Vordergrund
nginx -g 'daemon off;'
