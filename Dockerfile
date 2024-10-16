ARG NGINX_VERSION=mainline
ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-fpm-alpine
COPY config/php.ini-production "$PHP_INI_DIR/php.ini"

# Add php-extension helper and install extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd gmp sockets gettext pdo_mysql

FROM nginx:${NGINX_VERSION}-alpine AS stage
WORKDIR /var/www/html

# copy config
COPY config/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=3s CMD curl --silent --fail http://127.0.0.1:80/123status-traefik || exit 1