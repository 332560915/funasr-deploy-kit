# Update and Maintenance

This document is for maintenance after services are running. Corresponding script:

```text
scripts/update.sh
```

## Change HTTP API Configuration

File:

```text
/data/funasr/runtime/config/http-api.env
```

Update:

```bash
bash scripts/update.sh config /data/funasr
```

## Change Hotwords

File:

```text
/data/funasr/runtime/config/hotwords.txt
```

Update:

```bash
bash scripts/update.sh hotwords /data/funasr
```

## Change HTTP API Code

Directory:

```text
components/http-api
```

This rebuilds the HTTP API image and restarts `http-api`:

```bash
bash scripts/update.sh http-api /data/funasr
```

If the image has already been built:

```bash
bash scripts/update.sh http-api /data/funasr --no-build
```

## Change FunASR Server

Directory:

```text
components/funasr-server
```

Use this for Dockerfile, startup script, or C++ websocket server patch changes:

```bash
bash scripts/update.sh funasr-server /data/funasr
```

If the image has already been built:

```bash
bash scripts/update.sh funasr-server /data/funasr --no-build
```

## Update Models

Model directory:

```text
/data/funasr/runtime/models
```

After replacing models:

```bash
bash scripts/update.sh models /data/funasr
```

This stops the full stack, checks ports, and starts services again.

## Update Compose Template

If these files changed:

```text
deploy-template/docker-compose.yml
deploy-template/compose.env.template
deploy-template/README.md
deploy-template/README.en.md
```

Sync them to the runtime directory:

```bash
bash scripts/update.sh compose /data/funasr
```

This stops the full stack, syncs templates, checks ports, and starts services again.
