# FunASR Server Component

`funasr-server` is the FunASR websocket server component. It is built from the official FunASR CPU runtime image.

## Responsibilities

- Run the FunASR offline websocket ASR service.
- Load models from the external model directory `/workspace/models`.
- Read the startup script and hotwords from `/workspace/config`.
- Maintain `src/websocket-server.cpp` and only adjust the offline final response `is_final` value so it works with the official async client.

## Source Change

`src/websocket-server.cpp` comes from the official FunASR runtime file `runtime/websocket/bin/websocket-server.cpp`. This project no longer uses a Dockerfile `sed` replacement. The offline final response is changed directly in source so Git can track the modification clearly.

## Image

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## Related Documentation

- [Build Images](../../docs/en/deployment/build.md)
- [Configuration](../../docs/en/deployment/configuration.md)
- [FunASR final Message Notes](../../docs/en/reference/funasr-is-final.md)
- [Troubleshooting](../../docs/en/operations/troubleshooting.md)
