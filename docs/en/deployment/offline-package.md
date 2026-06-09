# Offline Package

This document is for the online packaging environment. Corresponding script:

```text
scripts/package-offline.sh
```

## Prerequisites

- Docker and Docker Compose v2 are installed.
- The packaging machine has `rsync`, `tar`, and `sha256sum` installed.
- `deploy-template/config/http-api.env.template` has been checked.
- FunASR model files have been placed under `deploy-template/models`.

Offline environments cannot download models, so `deploy-template/models` must exist and must not be empty.

## Package

By default, the script builds images before creating the offline package:

```bash
bash scripts/package-offline.sh
```

If images already exist, skip the build step:

```bash
bash scripts/package-offline.sh --no-build
```

`--no-build` checks whether required images exist locally. Missing images fail early.

Specify output directory:

```bash
bash scripts/package-offline.sh /data/offline-package
```

## Output

Default output:

```text
dist/funasr-deploy-kit-offline/
dist/funasr-deploy-kit-offline.tar.gz
```

Recommended transfer file:

```text
funasr-deploy-kit-offline.tar.gz
```

## Package Layout

```text
funasr-deploy-kit-offline/
|-- README.md
|-- README.en.md
|-- install.sh
|-- offline-data/
|   |-- funasr-images.tar
|   |-- runtime-data.tgz
|   `-- SHA256SUMS.txt
`-- funasr-deploy-kit/
    |-- components/
    |-- deploy-template/
    |-- docs/
    `-- scripts/
```

Notes:

- `install.sh`: outer offline install entrypoint, copied from `deploy-template/offline-package/install.sh`.
- `README.md`, `README.en.md`: offline package notes copied from `deploy-template/offline-package/`.
- `offline-data/funasr-images.tar`: Docker image archive.
- `offline-data/runtime-data.tgz`: runtime data archive containing `config/` and `models/`.
- `funasr-deploy-kit/`: project reference directory with scripts, docs, templates, and source code.

## Exclusion Rules

When copying the project reference directory, the script uses the repository root `.gitignore` as the main exclusion rule source and also excludes:

```text
.git/
current output directory
```

This avoids copying Git metadata, virtual environments, models, logs, and generated offline packages into the project reference directory.

Models are not copied as project source files. They are included in:

```text
offline-data/runtime-data.tgz
```
