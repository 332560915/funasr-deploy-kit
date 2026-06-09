# FunASR Offline Final Message Notes

The current deployment uses the FunASR offline websocket service. The server can recognize audio and return `text` and `timestamp`, but the upstream C++ offline server sets `is_final` to `false` by default.

The official `funasr-python` `AsyncFunASRClient` waits for the final result. If the server closes the websocket normally with code `1000` before sending `is_final=true`, the client continues waiting and eventually appears stuck or raises an exception.

This project first copies the official `runtime/websocket/bin/websocket-server.cpp` into the repository:

```text
components/funasr-server/src/websocket-server.cpp
```

To add compatibility for the official async client, this project changes the final response location of this offline C++ websocket server explicitly:

```text
jsonresult["is_final"] = false;
```

changed to:

```text
jsonresult["is_final"] = true;
```

Patched image name:

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

This project targets file transcription, so it uses offline mode first. Compared with low-latency streaming mode, offline mode is better suited for full-file recognition and matches the gateway API semantics of uploading a file and returning complete text.

Note: this change targets only the offline response of `funasr-wss-server`. If `online` or `2pass` support is added later, do not mark every response as `is_final=true`; final semantics must be handled per mode.
