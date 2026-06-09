# funasr-deploy-kit

[中文](README.md)

Docker deployment kit for FunASR with HTTP API and offline delivery support.

`funasr-deploy-kit` packages a deployable FunASR service stack. It runs the FunASR websocket server in Docker, wraps it with an HTTP file transcription API, and provides deployment files, offline packaging scripts, externalized configuration, logs, hotwords, and documentation for intranet or offline delivery scenarios.

## Purpose

- File-based speech-to-text API: `POST /api/v1/asr`.
- Built-in Swagger UI for browser testing: `/docs`.
- Containerized FunASR offline websocket server.
- External mounts for models, hotwords, configuration, logs, and temporary files.
- Online image build and offline package delivery.
- Linux deployment, update, and migration scripts.
- Extensible component layout for future websocket gateway or async task APIs.

## Project Layout

```text
.
|-- components/
|   |-- http-api/           HTTP file transcription API component
|   `-- funasr-server/      FunASR websocket server component
|-- deploy-template/        Deployment and config templates, not the runtime directory
|-- scripts/                Quick start, online deploy, offline package, offline install, and update scripts
`-- docs/
    |-- zh/                 Chinese documentation
    `-- en/                 English documentation
```

## Quick Links

- [Getting Started](docs/en/usage/getting-started.md)
- [HTTP API](docs/en/usage/api.md)
- [Online Deployment](docs/en/deployment/deploy.md)
- [Configuration](docs/en/deployment/configuration.md)
- [Offline Packaging](docs/en/deployment/offline-package.md)
- [Offline Deployment](docs/en/deployment/offline-deploy.md)
- [Update and Maintenance](docs/en/operations/update.md)
- [Troubleshooting](docs/en/operations/troubleshooting.md)

## More Documentation

- [Full English Documentation Map](docs/en/index.md)
- [中文文档](README.md)
- [Changelog](docs/CHANGELOG.en.md)

## Development and Maintenance

- [Components Directory](components/README.en.md)
- [HTTP API Component](components/http-api/README.en.md)
- [FunASR Server Component](components/funasr-server/README.en.md)
- [Runtime README Template](deploy-template/README.en.md)
- [Scripts](scripts/README.en.md)
