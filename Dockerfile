ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-fpm-alpine AS php

ENV WEBROOT=/var/www/html

# Install nginx and utilities
RUN apk update && \
    apk add --no-cache nginx envsubst iputils-ping curl && \
    mkdir -p /run/nginx

WORKDIR /var/www/html

# copy config
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf.tmpl


EXPOSE 80


COPY config/php.ini-production "$PHP_INI_DIR/php.ini"

# Configure PHP-FPM to log errors to stderr (which will appear in docker logs)
# Only log errors and warnings, no notices. Never display errors on website.
RUN echo "error_log = /proc/self/fd/2" >> "$PHP_INI_DIR/php.ini" && \
    echo "display_errors = Off" >> "$PHP_INI_DIR/php.ini" && \
    echo "display_startup_errors = Off" >> "$PHP_INI_DIR/php.ini" && \
    echo "log_errors = On" >> "$PHP_INI_DIR/php.ini" && \
    echo "error_reporting = E_ERROR | E_WARNING | E_PARSE" >> "$PHP_INI_DIR/php.ini" && \
    echo "catch_workers_output = yes" >> /usr/local/etc/php-fpm.d/www.conf && \
    echo "decorate_workers_output = no" >> /usr/local/etc/php-fpm.d/www.conf

# COPY --from=nginx /etc/nginx /etc/nginx
# COPY --from=nginx /etc/nginx /etc/nginx
# COPY --from=php /usr/local/bin/php /usr/local/bin/php

# Add php-extension helper and install extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd gmp sockets gettext pdo_mysql mysqli

COPY entry/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh && \
    sed -i 's/\r$//' /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=1s CMD curl --silent --fail http://127.0.0.1:80/123status-traefik || exit 1