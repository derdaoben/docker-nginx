ARG NGINX_VERSION=mainline
FROM nginx:${NGINX_VERSION}-alpine

WORKDIR /var/www/html

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY config/conf.d /etc/nginx/conf.d/

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/ || exit 1