ARG NGINX_VERSION=mainline

FROM nginx:${NGINX_VERSION}-alpine AS stage
WORKDIR /var/www/html

# copy config
COPY config/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf
COPY src/status.html /var/www/html/status.html
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=3s CMD curl --silent --fail http://127.0.0.1:80/123status-traefik || exit 1