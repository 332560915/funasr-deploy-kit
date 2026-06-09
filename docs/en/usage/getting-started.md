# Getting Started

This guide is for first-time users. It gets FunASR Server and HTTP API running with the default configuration.

If the target machine has no network access, see [Offline Deployment](../deployment/offline-deploy.md).

## Clone the Project

```bash
git clone https://github.com/332560915/funasr-deploy-kit.git
cd funasr-deploy-kit
```

## Requirements

- A Linux server, or a Linux/macOS environment that can run Docker.
- Docker installed.
- Docker Compose v2 installed, using the `docker compose` command.
- Network access to Docker image sources during the first image build.
- Network access to model download sources on first startup if models are not prepared in advance.

Check commands:

```bash
docker --version
docker compose version
```

## Quick Start

For first-time use, do not add `--no-build`. The script builds images, creates the runtime directory, and starts services:

```bash
bash scripts/quick-start.sh
```

Default runtime directory:

```text
/data/funasr
```

Use another directory:

```bash
bash scripts/quick-start.sh /opt/funasr
```

## Verify

Enter the runtime directory:

```bash
cd /data/funasr
docker compose ps
```

Health check:

```bash
curl http://127.0.0.1:18000/health
```

Swagger test page:

```text
http://127.0.0.1:18000/docs
```

Upload an audio or video file:

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

The synchronous API defaults to a 30MB upload limit. Use a short audio file or a small file for first verification.

## Next Steps

- API usage: [HTTP API](api.md)
- Online deployment: [Online Deployment](../deployment/deploy.md)
- Configuration: [Configuration](../deployment/configuration.md)
- Build an offline package: [Offline Package](../deployment/offline-package.md)
- Install without network access: [Offline Deployment](../deployment/offline-deploy.md)
