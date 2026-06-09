# Image Build Notes

Image builds are included in scenario scripts. There is no separate user-facing build-only script.

## Image Build Scenarios

Quick start:

```bash
bash scripts/quick-start.sh
```

Online deployment:

```bash
bash scripts/deploy-online.sh /data/funasr
```

Offline packaging:

```bash
bash scripts/package-offline.sh
```

These scripts build required images by default.

## Skip Build

If images already exist, use `--no-build`:

```bash
bash scripts/deploy-online.sh /data/funasr --no-build
bash scripts/package-offline.sh --no-build
```

The script checks whether required images exist locally. Missing images fail early.

## Update One Component

Update HTTP API:

```bash
bash scripts/update.sh http-api /data/funasr
```

Update FunASR Server:

```bash
bash scripts/update.sh funasr-server /data/funasr
```

## Image Name Source

Image names come from:

```text
deploy-template/compose.env.template
```

Defaults:

```env
FUNASR_SERVER_IMAGE=local/funasr-runtime-sdk-cpu:0.4.7-is-final
HTTP_API_IMAGE=local/http-api:latest
```

Build, startup, and offline packaging all read the same template to keep image names consistent.

## Cache Notes

Docker reuses build cache by layer. The HTTP API image installs dependencies before copying business code, so changing Python code usually does not reinstall dependencies.

The FunASR Server image compiles `funasr-wss-server`. If the base image, Dockerfile, and related sources do not change, that compile layer can usually reuse cache.
