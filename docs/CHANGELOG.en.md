# Changelog

This file records important changes for `funasr-deploy-kit`.

The project has not been formally released yet. New entries should be added only when a release version or important change is explicitly introduced.

## [Unreleased] - 2026-06-09

### Refactoring

- Refactor project directory semantics and clarify the responsibilities of `components/`, `deploy-template/`, `scripts/`, and `docs/`.
- Reorganize deployment scripts by scenario, covering quick start, online deployment, offline packaging, offline installation, and updates.
- Split shared script helpers and add argument checks, image checks, port prechecks, and Chinese user-facing messages.
- Refactor deployment templates to generate a consistent runtime directory with `docker-compose.yml`, `.env`, `runtime/`, and runtime notes.
- Refactor offline delivery so packages include project reference files, offline data, install scripts, and usage notes.
- Reorganize Chinese and English documentation by quick usage, deployment delivery, operations, and background references.
- Update root README files and documentation maps so main entries link directly to final documents with fewer navigation hops.
- Clean up `.gitignore` by removing duplicate and stale entries while keeping ignores for models, runtime artifacts, offline packages, and local environment files.

## [0.1.0] - 2026-06-08

### Initial Version

- Provide containerized FunASR Server deployment based on the official FunASR CPU runtime image.
- Provide a file-based HTTP API for audio or video upload and text transcription.
- Use the official `funasr-python` `AsyncFunASRClient` to call the FunASR websocket service.
- Provide online build, Compose startup, offline packaging, and offline deployment capabilities.
- Support external mounts for configuration, hotwords, models, logs, and temporary directories.
- Patch the FunASR offline websocket server with `is_final=true` to work with the official async client.
- Provide Chinese and English documentation, Swagger testing entrypoint, and changelog.
