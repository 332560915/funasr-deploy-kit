# Offline Deployment

Offline environments should only load images and start containers. Do not rebuild images on offline servers. Build and verify the platform in an online environment first, then create a complete offline package.

## Package in Online Environment

Make sure runtime configuration is ready:

```bash
cp deploy/config/http-api.env.example deploy/config/http-api.env
vi deploy/config/http-api.env
```

Build images:

```bash
bash scripts/build.sh
```

Package offline materials:

```bash
bash scripts/package-offline.sh
```

Default output:

```text
dist/funasr-deploy-kit-offline.tar.gz
```

`package-offline.sh` checks whether `deploy/config/http-api.env` exists. This file is not committed to the repository, so copy it from `.example` and confirm the values before packaging.

The script also checks that `deploy/models` exists and is not empty. Offline environments cannot download models, so place FunASR models under `deploy/models` before packaging.

## Install in Offline Environment

Copy `funasr-deploy-kit-offline.tar.gz` to the offline server and extract it:

```bash
tar -xzf funasr-deploy-kit-offline.tar.gz
cd funasr-deploy-kit-offline
```

Install to `/data/funasr` by default:

```bash
bash install.sh
```

Install to `/opt/funasr`:

```bash
bash install.sh /opt
```

The install script displays:

```text
offline data directory
project directory
install root
final deployment directory
```

and asks for confirmation before continuing. To skip confirmation:

```bash
bash install.sh /opt --yes
```

You can also call the lower-level load script directly:

```bash
cd funasr-deploy-kit
bash scripts/load-offline.sh ../offline-data /data
```

Arguments:

```text
first argument: offline data directory, defaults to ../offline-data next to the project directory
second argument: install root, defaults to /data
final deployment directory: install root/funasr
```

## Verify

```bash
cd /data/funasr
docker compose -f docker-compose.offline.yml ps
curl http://127.0.0.1:18000/health
curl -F "file=@/data/funasr/models/audio/test.mp4" http://127.0.0.1:18000/api/v1/asr
```
