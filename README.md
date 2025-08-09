# Docker Nginx + PHP-FPM mit OpenTelemetry Tracing

Ein Docker-Container, der Nginx und PHP-FPM mit integriertem OpenTelemetry Tracing für Jaeger kombiniert.

## 🚀 Features

- **Nginx + PHP-FPM**: Hochperformante Webserver-Konfiguration
- **OpenTelemetry Integration**: 
  - Nginx OpenTelemetry Modul (aus Quellcode kompiliert)
  - PHP OpenTelemetry Extension
- **Jaeger Tracing**: Vollständige Request-Verfolgung
- **Alpine Linux**: Minimale Container-Größe
- **Healthcheck**: Automatische Gesundheitsüberwachung

## 📦 Schnellstart

### Container bauen
```bash
docker build -t nginx-php-otel .
```

### Container starten (einfach)
```bash
docker run -d -p 80:80 --name nginx-php nginx-php-otel
```

### Mit Jaeger (empfohlen)
Erstellen Sie eine `docker-compose.yml`:

```yaml
version: '3.8'

services:
  nginx-php:
    build: .
    ports:
      - "80:80"
    environment:
      - WEBROOT=/var/www/html
      # OpenTelemetry Konfiguration
      - OTEL_SERVICE_NAME=nginx-php-app
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://jaeger:4318
      - OTEL_TRACES_EXPORTER=otlp
    depends_on:
      - jaeger

  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "16686:16686"  # Jaeger UI
      - "4318:4318"    # OTLP HTTP receiver
    environment:
      - COLLECTOR_OTLP_ENABLED=true
```

Dann starten:
```bash
docker-compose up -d
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
| `OTEL_SERVICE_NAME` | - | Service-Name in Jaeger |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | - | Jaeger OTLP Endpoint |
| `OTEL_TRACES_EXPORTER` | `otlp` | Trace Exporter Type |

### PHP Extensions

Installierte Extensions:
- `gd` - Bildverarbeitung
- `gmp` - Mathematische Funktionen
- `sockets` - Socket-Kommunikation
- `gettext` - Internationalisierung
- `pdo_mysql` - MySQL PDO Driver
- `mysqli` - MySQL Improved Extension
- `opentelemetry` - OpenTelemetry Tracing

## 📊 Monitoring & Tracing

### Jaeger UI
Nach dem Start mit docker-compose:
- **URL**: http://localhost:16686
- **Service**: Wählen Sie "nginx-php-app"
- **Traces**: Zeigt alle HTTP-Requests

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
docker run -v $(pwd)/src:/var/www/html -p 80:80 nginx-php-otel
```

### Custom Nginx Konfiguration
Bearbeiten Sie `config/nginx.conf` oder `config/default.conf` und rebuilden Sie:
```bash
docker build -t nginx-php-otel .
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

## 🔍 OpenTelemetry Details

### Nginx Tracing
- **Automatisch**: Jeder HTTP-Request wird getrackt
- **Attribute**: Method, URI, Status Code, Response Time
- **Span Namen**: Basierend auf Request-Typ (php_request, static_asset)

### PHP Tracing
- **Extension**: OpenTelemetry PHP Extension
- **Auto-Instrumentation**: HTTP-Requests und Database-Queries
- **Custom Spans**: Können im PHP-Code hinzugefügt werden

### Trace Korrelation
- Nginx-Traces und PHP-Traces sind automatisch verknüpft
- Trace-IDs werden über FastCGI-Parameter übertragen
- Vollständige Request-Pipeline sichtbar

## 🚨 Troubleshooting

### Container startet nicht
```bash
# Logs prüfen
docker logs nginx-php

# Konfiguration testen
docker run --rm nginx-php-otel nginx -t
```

### Tracing funktioniert nicht
1. Prüfen Sie die Jaeger-Verbindung
2. Kontrollieren Sie Umgebungsvariablen
3. Logs auf OpenTelemetry-Fehler prüfen

### Performance-Probleme
- Container-Ressourcen erhöhen
- PHP-FPM Worker anpassen in `config/default.conf`
- Nginx Worker Processes in `config/nginx.conf`

## 📚 Weiterführende Links

- [OpenTelemetry Documentation](https://opentelemetry.io/)
- [Jaeger Tracing](https://www.jaegertracing.io/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.php)

## 📄 Lizenz

MIT License - siehe Details in der jeweiligen Software-Dokumentation.
