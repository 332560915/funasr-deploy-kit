# FunASR Offline Final Message Notes

The current deployment uses the FunASR offline websocket service. The server can recognize audio and return `text` and `timestamp`, but the upstream C++ offline server sets `is_final` to `false` by default.

The official `funasr-python` `AsyncFunASRClient` waits for the final result. If the server closes the websocket normally with code `1000` before sending `is_final=true`, the client continues waiting and eventually appears stuck or raises an exception.

This project patches the C++ websocket server during FunASR image build:

```text
jsonresult["is_final"] = false;
```

is changed to:

```text
jsonresult["is_final"] = true;
```

Patched image name:

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

This project targets file transcription, so it uses offline mode first. Compared with low-latency streaming mode, offline mode is better suited for full-file recognition and matches the gateway API semantics of uploading a file and returning complete text.
