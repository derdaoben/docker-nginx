#!/bin/sh

# Start PHP-FPM im Hintergrund
php-fpm -D

# Starte nginx im Vordergrund
nginx -g 'daemon off;'