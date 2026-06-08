# funasr-deploy-kit

[中文](README.md)

Docker deployment kit for FunASR with HTTP API and offline delivery support.

`funasr-deploy-kit` packages a deployable FunASR service stack. It runs the FunASR websocket server in Docker, wraps it with an HTTP file transcription API, and provides deployment files, offline packaging scripts, externalized configuration, logs, hotwords, and documentation for intranet or offline delivery scenarios.

## Features

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
|-- deploy/                 Docker Compose files and deployment config examples
|-- scripts/                Build, package, and offline load scripts
`-- docs/
    |-- zh/                 Chinese documentation
    `-- en/                 English documentation
```

## English Documentation

- [Getting Started](docs/en/usage/getting-started.md)
- [HTTP API](docs/en/usage/api.md)
- [Configuration](docs/en/deployment/configuration.md)
- [Build Images](docs/en/deployment/build.md)
- [Deploy](docs/en/deployment/deploy.md)
- [Update](docs/en/operations/update.md)
- [Offline Package](docs/en/deployment/offline-package.md)
- [Offline Deployment](docs/en/deployment/offline-deploy.md)
- [Troubleshooting](docs/en/operations/troubleshooting.md)
- [FunASR final Message Notes](docs/en/reference/funasr-is-final.md)
- [Next Version Plan](docs/en/reference/next-version-plan.md)
- [Changelog](CHANGELOG.en.md)

## Component Entrypoints

- [HTTP API Component](components/http-api/README.en.md)
- [FunASR Server Component](components/funasr-server/README.en.md)
- [Deployment Directory](deploy/README.en.md)
- [Scripts](scripts/README.en.md)
