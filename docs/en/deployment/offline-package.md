# Offline Package

This document describes how to package offline deployment materials in an online environment.

## Prerequisites

- Both images have been built.
- `deploy/config/http-api.env` has been checked.
- FunASR model files have been placed under `deploy/models`.

## Build Images

```bash
bash scripts/build.sh
```

## Package

```bash
bash scripts/package-offline.sh
```

Default output:

```text
dist/funasr-images.tar
dist/funasr-runtime-data.tgz
```

You can also specify the output directory:

```bash
bash scripts/package-offline.sh /data/offline-package
```

## Artifacts

- `funasr-images.tar`: Docker image archive containing HTTP API and FunASR Server images.
- `funasr-runtime-data.tgz`: Runtime data archive containing Compose files, configuration, hotwords, startup scripts, and models.

## Checksum

```bash
sha256sum dist/funasr-images.tar dist/funasr-runtime-data.tgz
```
