# Troubleshooting

## HTTP API Cannot Connect to FunASR Server

Check `deploy/config/http-api.env`:

```env
FUNASR_WS_URL=ws://funasr-server:10095
```

Check container status:

```bash
docker compose -f deploy/docker-compose.yml ps
docker compose -f deploy/docker-compose.yml logs -f funasr-server
```

## Official Client Waits for Final Result

The FunASR offline websocket server needs to return `is_final=true`. The FunASR Server image in this project patches this behavior during image build.

See [FunASR final Message Notes](../reference/funasr-is-final.md) for background.

## Image Not Found in Offline Environment

Load the image archive first:

```bash
docker load -i funasr-images.tar
```

Then start with the offline Compose file:

```bash
docker compose -f docker-compose.offline.yml up -d
```

## Offline Packaging Failed

`scripts/package-offline.sh` checks:

- Whether `deploy/config/http-api.env` exists.
- Whether `deploy/models` exists and is not empty.

Follow the prompt, prepare the missing files, and run the package command again.

## Uploaded File Is Too Large

HTTP API controls the synchronous upload limit with `MAX_UPLOAD_SIZE`. The default sample value is 30MB. When the limit is exceeded, the API returns `413`.

Configuration file:

```text
deploy/config/http-api.env
```

## Responses Become Slow Under High Concurrency

Adjust these values according to machine resources and FunASR Server capacity:

```env
HTTP_API_LIMIT_CONCURRENCY=20
ASR_RECOGNITION_CONCURRENCY=10
```

`HTTP_API_LIMIT_CONCURRENCY` controls HTTP entrypoint concurrency. `ASR_RECOGNITION_CONCURRENCY` controls the business concurrency that can enter FunASR recognition.
