# HTTP API Component

`http-api` is the file-based HTTP API component. It receives audio or video uploads, writes them to a temporary directory, calls FunASR Server, and returns the transcription text.

## Responsibilities

- Provide the `POST /api/v1/asr` file transcription API.
- Provide Swagger UI at `/docs`.
- Enforce upload size limits and clean up temporary files.
- Use the official `funasr-python` `AsyncFunASRClient` to call the FunASR websocket service.
- Write loguru logs to `/app/logs` inside the container.

## Local Development

```bash
uv sync
uv run uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## Related Documentation

- [HTTP API](../../docs/en/usage/api.md)
- [Configuration](../../docs/en/deployment/configuration.md)
- [Image Build Notes](../../docs/en/deployment/build.md)
- [Update](../../docs/en/operations/update.md)
