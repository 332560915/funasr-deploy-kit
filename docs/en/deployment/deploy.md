# Deploy

This document describes how to start the platform in an online environment or in an environment where images already exist.

## Prepare Directories

Recommended deployment directory:

```text
/data/funasr
|-- docker-compose.yml
|-- docker-compose.offline.yml
|-- config/
|-- logs/
|-- models/
`-- tmp/
```

When starting locally inside the repository, use the `deploy/` directory directly.

## Prepare Configuration and Models

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
```

Put FunASR model files under:

```text
deploy/models
```

## Start Services

Build and start online:

```bash
docker compose -f deploy/docker-compose.yml up -d --build
```

Start when images already exist:

```bash
docker compose -f deploy/docker-compose.yml up -d
```

Start in an offline environment:

```bash
docker compose -f docker-compose.offline.yml up -d
```

## Check Status

```bash
docker compose -f deploy/docker-compose.yml ps
```

Inside `/data/funasr`:

```bash
docker compose ps
```

## View Logs

```bash
docker compose -f deploy/docker-compose.yml logs -f http-api
docker compose -f deploy/docker-compose.yml logs -f funasr-server
```

Host log directories:

```text
deploy/logs/http-api
deploy/logs/funasr-server
```

## Stop Services

```bash
docker compose -f deploy/docker-compose.yml down
```
