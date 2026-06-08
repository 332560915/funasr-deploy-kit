# Offline Deployment

Offline environments should only load images and start containers. Do not rebuild images on offline servers. Build and verify the platform in an online environment first, then export images and runtime data with the packaging script.

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
dist/funasr-images.tar
dist/funasr-runtime-data.tgz
```

`package-offline.sh` checks whether `deploy/config/http-api.env` exists. This file is not committed to the repository, so copy it from `.example` and confirm the values before packaging.

The script also checks that `deploy/models` exists and is not empty. Offline environments cannot download models, so place FunASR models under `deploy/models` before packaging.

## Import in Offline Environment

Copy the following two files to the same directory on the offline server, for example `/data`:

```text
funasr-images.tar
funasr-runtime-data.tgz
```

Run the load script:

```bash
bash scripts/load-offline.sh /data
```

The script will:

- Load Docker images.
- Extract runtime files to `/data/funasr`.
- Create log and temporary directories.
- Start `docker-compose.offline.yml`.

## Verify

```bash
cd /data/funasr
docker compose -f docker-compose.offline.yml ps
curl http://127.0.0.1:18000/health
curl -F "file=@/data/funasr/models/audio/test.mp4" http://127.0.0.1:18000/api/v1/asr
```
