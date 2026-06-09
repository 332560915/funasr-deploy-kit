# HTTP API

The HTTP API component provides file-based speech recognition. Callers can upload audio or video files directly without preprocessing them.

The current API is synchronous and is suitable for short audio, functional verification, and Swagger-based testing.

## Swagger

After services start, open:

```text
http://127.0.0.1:18000/docs
```

If deployed on a server, replace the host with the server IP:

```text
http://10.2.3.118:18000/docs
```

## Health Check

```bash
curl http://127.0.0.1:18000/health
```

Example response:

```json
{
  "status": "healthy"
}
```

## Recognition API

```text
POST /api/v1/asr
```

Request field:

```text
file  Audio or video file
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

## Service Info

```bash
curl http://127.0.0.1:18000/
```

This endpoint returns service name, version, and main endpoints.

## Upload Limit

Upload size is controlled by `MAX_UPLOAD_SIZE`. Default:

```env
MAX_UPLOAD_SIZE=31457280
```

This is 30MB. Requests exceeding the limit return `413`.

Configuration file:

```text
/data/funasr/runtime/config/http-api.env
```

Apply changes:

```bash
bash scripts/update.sh config /data/funasr
```
