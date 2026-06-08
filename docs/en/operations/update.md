# Update

Different changes require different update operations. Avoid unnecessary rebuilds.

## Change HTTP API Configuration

File:

```text
deploy/config/http-api.env
```

Update:

```bash
docker compose -f deploy/docker-compose.yml up -d http-api
```

## Change Hotwords

File:

```text
deploy/config/hotwords.txt
```

Update:

```bash
docker compose -f deploy/docker-compose.yml restart funasr-server
```

## Change FunASR Startup Script

File:

```text
deploy/config/start-funasr.sh
```

Update:

```bash
docker compose -f deploy/docker-compose.yml restart funasr-server
```

## Change HTTP API Code

Directory:

```text
components/http-api
```

Update:

```bash
docker compose -f deploy/docker-compose.yml build http-api
docker compose -f deploy/docker-compose.yml up -d http-api
```

## Change FunASR Server Image Build

Directory:

```text
components/funasr-server
```

Update:

```bash
docker compose -f deploy/docker-compose.yml build funasr-server
docker compose -f deploy/docker-compose.yml up -d funasr-server
```

## Update Models

Directory:

```text
deploy/models
```

Stop services first, replace models, then start services:

```bash
docker compose -f deploy/docker-compose.yml down
docker compose -f deploy/docker-compose.yml up -d
```
