# Docker Nginx + PHP-FPM

A Docker container that combines Nginx and PHP-FPM.

## 🚀 Features

- **Nginx + PHP-FPM**
- **Alpine Linux**
- **Healthcheck**

## 📦 Quick Start

> ⚠️ **Warning**: This container is designed for use with an ingress controller like Traefik. Therefore only port 80 enabled in nginx.

### Build container
```bash
docker build -t nginx-php .
```

### Start container (simple)
```bash
docker run -d -p 80:80 --name nginx-php nginx-php
```

### Compose
Create a `docker-compose.yml`:

```yaml
version: '3.8'

services:
  nginx-php:
    image: ghcr.io/derdaoben/nginx:master
    volumes:
      - /myWebsite:/var/www/html:ro
    ports:
      - "80:80"

```

Then start:
```bash
docker-compose up -d
```

## 🔧 Configuration

### Directory Structure
```
├── Dockerfile
├── config/
│   ├── nginx.conf          # Nginx main configuration
│   ├── default.conf        # Virtual host configuration
│   └── php.ini-production  # PHP configuration
├── entry/
│   └── docker-entrypoint.sh # Container startup script
└── README.md
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WEBROOT` | `/var/www/html` | Document Root |

### PHP Extensions

Installed extensions:
- `gd` - Image processing
- `gmp` - Mathematical functions
- `sockets` - Socket communication
- `gettext` - Internationalization
- `pdo_mysql` - MySQL PDO Driver
- `mysqli` - MySQL Improved Extension
- `pdo_pgsql` - PostgreSQL PDO Driver

## 📊 Monitoring

### Healthcheck
- **Endpoint**: http://localhost/123status-traefik
- **Interval**: Every 30 seconds
- **Timeout**: 3 seconds
- Logging enabled

### Logs
```bash
# Show container logs
docker logs nginx-php

# With docker-compose
docker-compose logs -f nginx-php
```

## 🛠️ Development

### Add custom PHP files
```bash
# Copy files to container
docker cp myapp.php nginx-php:/var/www/html/

# Or mount volume
docker run -v /myapp:/var/www/html -p 80:80 nginx-php
```

### Debugging
```bash
# Enter container
docker exec -it nginx-php /bin/sh

# Test Nginx configuration
docker exec nginx-php nginx -t

# PHP-FPM status
docker exec nginx-php php-fpm -t
```

## 📚 Further Reading

- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.php)

## 📄 License

MIT License - see details in the respective software documentation.
