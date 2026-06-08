# Deployment Directory

`deploy` is the runtime directory template. It contains Docker Compose files and external configuration examples. In production, this directory can be copied to `/data/funasr`.

## Files

```text
deploy/
|-- docker-compose.yml          Used for online build and startup
|-- docker-compose.offline.yml  Used in offline environments
`-- config/
    |-- http-api.env.example    HTTP API configuration example
    |-- hotwords.txt            Hotword file
    |-- hotwords.example.txt    Hotword example with Chinese comments
    `-- start-funasr.sh         FunASR Server startup script
```

Runtime directories are also required:

```text
deploy/models/                 FunASR model directory
deploy/logs/http-api/          HTTP API log directory
deploy/logs/funasr-server/     FunASR Server log directory
deploy/tmp/http-api/           HTTP API temporary upload directory
```

## Related Documentation

- [Getting Started](../docs/en/usage/getting-started.md)
- [Configuration](../docs/en/deployment/configuration.md)
- [Deploy](../docs/en/deployment/deploy.md)
- [Update](../docs/en/operations/update.md)
- [Offline Deployment](../docs/en/deployment/offline-deploy.md)
