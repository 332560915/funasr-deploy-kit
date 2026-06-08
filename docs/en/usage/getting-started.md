# Getting Started

This guide shows how to build and start the platform in an online environment.

## Prerequisites

- Docker is installed.
- Docker Compose v2 is installed.
- FunASR models are prepared under `deploy/models`.

## Prepare Configuration

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
vi deploy/config/http-api.env
```

Check these important values:

```env
FUNASR_WS_URL=ws://funasr-server:10095
UPLOAD_TEMP_DIR=/app/tmp
LOG_FILE=/app/logs/http-api.log
```

## Build and Start

```bash
docker compose -f deploy/docker-compose.yml build
docker compose -f deploy/docker-compose.yml up -d
```

You can also use the build script:

```bash
bash scripts/build.sh
docker compose -f deploy/docker-compose.yml up -d
```

## Verify

```bash
curl http://127.0.0.1:18000/health
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

Use a short audio file or a small media file for quick verification. The default upload limit for the synchronous API is 30MB.

For more deployment operations, see [Deploy](../deployment/deploy.md).
