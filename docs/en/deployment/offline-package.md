# Offline Package

This document describes how to create a complete offline delivery package in an online environment.

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

The default output directory is `dist/`, which contains:

```text
dist/funasr-deploy-kit-offline/
dist/funasr-deploy-kit-offline.tar.gz
```

You can also specify the output directory:

```bash
bash scripts/package-offline.sh /data/offline-package
```

## Package Layout

```text
funasr-deploy-kit-offline/
|-- README.md
|-- README.en.md
|-- install.sh
|-- offline-data/
|   |-- funasr-images.tar
|   |-- funasr-runtime-data.tgz
|   `-- SHA256SUMS.txt
`-- funasr-deploy-kit/
    |-- docs/
    |-- scripts/
    |-- deploy/
    `-- components/
```

## Artifacts

- `funasr-deploy-kit-offline.tar.gz`: Final delivery archive. This is the recommended file to transfer.
- `install.sh`: Offline installation entrypoint. It prompts for the install path and asks for confirmation.
- `offline-data/funasr-images.tar`: Docker image archive containing HTTP API and FunASR Server images.
- `offline-data/funasr-runtime-data.tgz`: Runtime data archive containing Compose files, configuration, hotwords, startup scripts, and models.
- `offline-data/SHA256SUMS.txt`: Checksum file for offline data.
- `funasr-deploy-kit/`: Project directory with scripts, documentation, deployment templates, and source code.

## Excluded Content

When copying the project directory, these paths are excluded:

```text
.git/
.idea/
.venv/
components/http-api/.venv/
deploy/models/
deploy/logs/
deploy/tmp/
dist/
dest/
*.tar
*.tgz
*.tar.gz
```

Models are not copied as project source files. They are included in `offline-data/funasr-runtime-data.tgz`.
