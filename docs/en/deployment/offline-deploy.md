# Offline Deployment

This document is for environments without network access. Offline targets only load images, restore runtime data, and start containers. They do not rebuild images.

## Prepare Offline Package

Create the offline package in an online environment:

```bash
bash scripts/package-offline.sh
```

Output:

```text
dist/funasr-deploy-kit-offline.tar.gz
```

Copy this archive to the offline server.

## Extract

```bash
tar -xzf funasr-deploy-kit-offline.tar.gz
cd funasr-deploy-kit-offline
```

## Install

Install to `/data/funasr` by default:

```bash
bash install.sh
```

Install to `/opt/funasr`:

```bash
bash install.sh /opt
```

Note: the outer `install.sh` receives an install root. `bash install.sh /opt` installs to `/opt/funasr`.

Skip confirmation:

```bash
bash install.sh /opt --yes
```

## Install Steps

The installer:

- Verifies `offline-data/SHA256SUMS.txt`.
- Imports images with `docker load`.
- Stops and backs up the old runtime directory if it already exists.
- Restores runtime data into `runtime/`.
- Copies `docker-compose.yml`, `.env`, and runtime `README.md`.
- Checks `FUNASR_HOST_PORT` and `HTTP_API_PORT` before startup.
- Starts services.

## Result

Default runtime directory:

```text
/data/funasr/
|-- docker-compose.yml
|-- .env
|-- README.md
|-- README.en.md
`-- runtime/
```

`funasr-deploy-kit/` is a project reference directory with scripts, docs, and source code. It can be removed after installation if only the running service is needed.

## Verify

```bash
cd /data/funasr
docker compose ps
curl http://127.0.0.1:18000/health
```

Swagger test page:

```text
http://127.0.0.1:18000/docs
```

Upload a file:

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

The lower-level install script can also be called directly:

```bash
cd funasr-deploy-kit
bash scripts/install-offline.sh ../offline-data /data/funasr
```
