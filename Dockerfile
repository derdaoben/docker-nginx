ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-fpm-alpine AS php

ENV WEBROOT=/var/www/html

# Installiere nginx und build-Abhängigkeiten
RUN apk update && \
    apk add --no-cache nginx envsubst iputils-ping curl wget \
    build-base cmake git && \
    mkdir -p /run/nginx

# Build Nginx OpenTelemetry module from source (robuster als Binary-Download)
RUN cd /tmp && \
    git clone --recurse-submodules https://github.com/open-telemetry/opentelemetry-cpp-contrib.git && \
    cd opentelemetry-cpp-contrib/instrumentation/nginx && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DNGINX_BIN=/usr/sbin/nginx \
          .. && \
    make -j$(nproc) && \
    mkdir -p /etc/nginx/modules && \
    cp otel_ngx_module.so /etc/nginx/modules/ && \
    cd / && rm -rf /tmp/opentelemetry-cpp-contrib && \
    apk del build-base cmake git

WORKDIR /var/www/html

# copy config
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf.tmpl


EXPOSE 80


COPY config/php.ini-production "$PHP_INI_DIR/php.ini"

# COPY --from=nginx /etc/nginx /etc/nginx
# COPY --from=nginx /etc/nginx /etc/nginx
# COPY --from=php /usr/local/bin/php /usr/local/bin/php

# Add php-extension helper and install extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd gmp sockets gettext pdo_mysql mysqli

# Install OpenTelemetry extension for tracing
RUN install-php-extensions opentelemetry

COPY entry/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=3s CMD curl --silent --fail http://127.0.0.1:80/123status-traefik.php || exit 1