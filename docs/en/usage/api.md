# HTTP API

The HTTP API component provides file-based speech recognition. Callers can upload audio or video files directly without preprocessing them.

The current synchronous transcription API is suitable for short audio, functional verification, and Swagger-based testing.

## Swagger UI

After the service starts, open the built-in Swagger UI in a browser:

```text
http://127.0.0.1:18000/docs
```

If the service is deployed on a server, replace the host with the server IP:

```text
http://10.2.3.118:18000/docs
```

Choose `/api/v1/asr` in Swagger, upload a file, and test the transcription result. Swagger is best used with short audio or small files.

## Transcription API

```text
POST /api/v1/asr
```

Example:

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

Example response:

```json
{
  "code": 0,
  "text": "transcription text"
}
```

## Health Check

```bash
curl http://127.0.0.1:18000/health
```

Response:

```json
{
  "status": "healthy"
}
```

## Service Info

```bash
curl http://127.0.0.1:18000/
```

This endpoint returns the service name, version, and main endpoints.

## Upload Limit

The upload size is controlled by `MAX_UPLOAD_SIZE`. The default sample value is `31457280`, which is 30MB. The HTTP API writes uploaded files in chunks and returns `413` when the limit is exceeded.

`POST /api/v1/asr` is synchronous. The request waits for upload, forwarding to FunASR, recognition, and response delivery.
