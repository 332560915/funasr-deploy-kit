# FunASR Server Component

`funasr-server` is the FunASR websocket server component. It is built from the official FunASR CPU runtime image.

## Responsibilities

- Run the FunASR offline websocket ASR service.
- Load models from the external model directory `/workspace/models`.
- Include `start-funasr.sh` in the image and read model, thread, and SSL startup parameters from environment variables.
- Read hotwords and other runtime configuration from `/workspace/config`.
- Maintain `src/websocket-server.cpp` and only adjust the offline final response `is_final` value so it works with the official async client.

## Source Change

`src/websocket-server.cpp` comes from the official FunASR runtime file `runtime/websocket/bin/websocket-server.cpp`. This project adds the `is_final` value to the offline final response so it works with the official async client.

## Image

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## Related Documentation

- [Image Build Notes](../../docs/en/deployment/build.md)
- [Configuration](../../docs/en/deployment/configuration.md)
- [FunASR final Message Notes](../../docs/en/reference/funasr-is-final.md)
- [Troubleshooting](../../docs/en/operations/troubleshooting.md)
