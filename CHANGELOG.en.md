# Changelog

This file records important changes for `funasr-deploy-kit`.

The project has not been formally released yet. New entries should be added only when a release version or important change is explicitly introduced.

## [0.1.0] - 2026-06-08

### Initial Version

- Provide containerized FunASR Server deployment based on the official FunASR CPU runtime image.
- Provide a file-based HTTP API for audio or video upload and text transcription.
- Use the official `funasr-python` `AsyncFunASRClient` to call the FunASR websocket service.
- Provide online build, Compose startup, offline packaging, and offline deployment capabilities.
- Support external mounts for configuration, hotwords, models, logs, and temporary directories.
- Patch the FunASR offline websocket server with `is_final=true` to work with the official async client.
- Provide Chinese and English documentation, Swagger testing entrypoint, and changelog.
