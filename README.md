# Docker Nginx + PHP-FPM

Docker-Container mit nginx und php

## 🚀 Features

- **Nginx + PHP-FPM**
- **Alpine Linux**
- **Healthcheck**: Für Docker & Endpunkt für alle

## 📦 Schnellstart

### Container bauen
```bash
docker build -t nginx-php .
```

### Container starten (einfach)
```bash
docker run -d -p 80:80 --name nginx-php nginx-php
```

## 🔧 Konfiguration

### Verzeichnisstruktur
```
├── Dockerfile
├── config/
│   ├── nginx.conf          # Nginx Hauptkonfiguration
│   ├── default.conf        # Virtual Host Konfiguration
│   └── php.ini-production  # PHP Konfiguration
├── entry/
│   └── docker-entrypoint.sh # Container-Startskript
└── README.md
```

### Umgebungsvariablen

| Variable | Standard | Beschreibung |
|----------|----------|--------------|
| `WEBROOT` | `/var/www/html` | Document Root |

### PHP Extensions

Installierte Extensions:
- `gd` - Bildverarbeitung
- `gmp` - Mathematische Funktionen
- `sockets` - Socket-Kommunikation
- `gettext` - Internationalisierung
- `pdo_mysql` - MySQL PDO Driver
- `mysqli` - MySQL Improved Extension

## 📊 Monitoring & Tracing

### Healthcheck
- **Endpoint**: http://localhost/123status-traefik.php
- **Intervall**: Alle 30 Sekunden
- **Timeout**: 3 Sekunden

### Logs
```bash
# Container-Logs anzeigen
docker logs nginx-php

# Mit docker-compose
docker-compose logs -f nginx-php
```

## 🛠️ Entwicklung

### Eigene PHP-Dateien hinzufügen
```bash
# Dateien in den Container kopieren
docker cp myapp.php nginx-php:/var/www/html/

# Oder Volume mounten
docker run -v $(pwd)/src:/var/www/html -p 80:80 nginx-php
```

### Custom Nginx Konfiguration
Bearbeite `config/nginx.conf` oder `config/default.conf`:
```bash
docker build -t nginx-php .
```

### Debugging
```bash
# In Container einsteigen
docker exec -it nginx-php /bin/sh

# Nginx-Konfiguration testen
docker exec nginx-php nginx -t

# PHP-FPM Status
docker exec nginx-php php-fpm -t
```

## 📚 Weiterführende Links

- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.php)

## 📄 Lizenz

MIT License - siehe Details in der jeweiligen Software-Dokumentation.
