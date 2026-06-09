# FunASR Server Component

`funasr-server` is the FunASR websocket server component. It is built from the official FunASR CPU runtime image.

## Responsibilities

- Run the FunASR offline websocket ASR service.
- Load models from the external model directory `/workspace/models`.
- Read the startup script and hotwords from `/workspace/config`.
- Maintain the official source baseline in `src/websocket-server.cpp` so later compatibility changes can be tracked clearly by Git.

## Source Change

`src/websocket-server.cpp` comes from the official FunASR runtime file `runtime/websocket/bin/websocket-server.cpp`. This project no longer uses a Dockerfile `sed` replacement. The file currently keeps the official source. If the offline final response needs to be changed later, the difference will be committed directly in this source file.

## Image

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## Related Documentation

- [Build Images](../../docs/en/deployment/build.md)
- [Configuration](../../docs/en/deployment/configuration.md)
- [FunASR final Message Notes](../../docs/en/reference/funasr-is-final.md)
- [Troubleshooting](../../docs/en/operations/troubleshooting.md)
