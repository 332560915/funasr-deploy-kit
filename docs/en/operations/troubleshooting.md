# Troubleshooting

## Docker Is Not Available

Symptom:

```text
错误：Docker 不可用，请启动 Docker 或检查当前用户权限。
```

Check:

```bash
docker info
```

If it is a permission issue, use a user with Docker permissions.

## Docker Compose Is Not Available

Symptom:

```text
错误：Docker Compose v2 不可用，请安装 docker compose 插件。
```

Check:

```bash
docker compose version
```

## rsync Is Missing

`package-offline.sh` uses `rsync` and `.gitignore` to exclude unnecessary project files.

Check on the packaging machine:

```bash
rsync --version
```

The offline installation target does not need `rsync`.

## Port Conflict

Deployment and offline installation check these ports before startup:

```text
FUNASR_HOST_PORT
HTTP_API_PORT
```

If a port is occupied, change the runtime `.env`:

```text
/data/funasr/.env
```

or stop the service occupying that port.

## Image Missing

When using `--no-build`, required images must already exist locally. Check:

```bash
docker images
```

If an image is missing, rerun the scenario without `--no-build`.

## Models Missing

Offline packaging requires:

```text
deploy-template/models
```

It must exist and must not be empty. Offline targets cannot download models, so prepare models before packaging.

## HTTP API Cannot Connect to FunASR Server

Check:

```text
/data/funasr/runtime/config/http-api.env
```

It should contain:

```env
FUNASR_WS_URL=ws://funasr-server:10095
```

Check logs:

```bash
cd /data/funasr
docker compose logs -f funasr-server
docker compose logs -f http-api
```

## Uploaded File Is Too Large

The default upload limit is 30MB. Requests exceeding it return `413`.

Change:

```text
/data/funasr/runtime/config/http-api.env
```

Apply:

```bash
bash scripts/update.sh config /data/funasr
```

## Recognition Timeout

The synchronous API waits for upload, forwarding, recognition, and response. Adjust these values if needed:

```env
FUNASR_FINAL_TIMEOUT=120
REQUEST_TIMEOUT=360
TIMEOUT_KEEP_ALIVE=360
```

Configuration file:

```text
/data/funasr/runtime/config/http-api.env
```

## Official Client Waits for Final Result

The FunASR offline websocket server needs to return `is_final=true`. The FunASR Server image in this project includes a compatibility patch.

See [FunASR final Message Notes](../reference/funasr-is-final.md) for background.
