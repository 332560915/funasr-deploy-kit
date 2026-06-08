# FunASR Server Component

`funasr-server` is the FunASR websocket server component. It is built from the official FunASR CPU runtime image.

## Responsibilities

- Run the FunASR offline websocket ASR service.
- Load models from the external model directory `/workspace/models`.
- Read the startup script and hotwords from `/workspace/config`.
- Patch the offline server response with `is_final=true` during image build so it works with the official async client.

## Image

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## Related Documentation

- [Build Images](../../docs/en/deployment/build.md)
- [Configuration](../../docs/en/deployment/configuration.md)
- [FunASR final Message Notes](../../docs/en/reference/funasr-is-final.md)
- [Troubleshooting](../../docs/en/operations/troubleshooting.md)
