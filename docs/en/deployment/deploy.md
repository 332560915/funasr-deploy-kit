# Online Deployment

This document is for formal online deployment. Corresponding script:

```text
scripts/deploy-online.sh
```

## When to Use

- The target machine can build images online, or required images already exist locally.
- You need an independent runtime directory such as `/data/funasr`.
- Services should later be managed from the runtime directory.

## Deploy

By default, the script builds images, creates the runtime directory, and starts services:

```bash
bash scripts/deploy-online.sh /data/funasr
```

If images already exist, skip the build step:

```bash
bash scripts/deploy-online.sh /data/funasr --no-build
```

`--no-build` checks whether required images exist locally. Missing images fail early.

Create the runtime directory without starting services:

```bash
bash scripts/deploy-online.sh /data/funasr --no-start
```

Skip confirmation:

```bash
bash scripts/deploy-online.sh /data/funasr --yes
```

## Existing Runtime Directory

If the target directory already exists, the script tries to stop old services and backs up the old directory:

```text
/data/funasr.bak-YYYYMMDDHHMMSS
```

This avoids mixing old and new runtime files.

## Port Check

After old services are stopped and before new services start, the script checks:

```text
FUNASR_HOST_PORT
HTTP_API_PORT
```

Default ports:

```text
10095
18000
```

If a port is occupied by another service, change `/data/funasr/.env` or stop that service.

## Manage Services

Manage services from the runtime directory:

```bash
cd /data/funasr
docker compose ps
docker compose up -d
docker compose logs -f http-api
docker compose logs -f funasr-server
docker compose down
```

The runtime `README.md` also contains common commands and documentation links.
