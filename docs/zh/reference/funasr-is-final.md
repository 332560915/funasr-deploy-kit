# FunASR 离线最终消息说明

当前部署使用 FunASR offline websocket 服务。服务端可以正常识别音频，并返回 `text` 和 `timestamp`，但上游 C++ offline server 默认把响应里的 `is_final` 设置为 `false`。

官方 `funasr-python` 的 `AsyncFunASRClient` 会等待 final 结果。如果服务端在发送 `is_final=true` 之前就以 websocket `1000` 正常关闭，客户端就会继续等待，最后表现为卡住或抛异常。

本项目先把官方 `runtime/websocket/bin/websocket-server.cpp` 拷贝到仓库：

```text
components/funasr-server/src/websocket-server.cpp
```

兼容官方异步客户端时，本项目在该文件中明确修改 offline server 的最终响应位置：

```text
jsonresult["is_final"] = false;
```

改为：

```text
jsonresult["is_final"] = true;
```

修改为：

```text
jsonresult["is_final"] = true;
```

镜像名：

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

本项目面向文件转写场景，因此优先使用 offline 模式。相比低延迟流式模式，offline 模式更适合完整文件识别，也更符合“上传文件后返回完整文本”的网关接口语义。

注意：该修改只针对 `funasr-wss-server` 的 offline 响应。后续如果支持 `online` 或 `2pass`，不能把所有响应都设为 `is_final=true`，需要按对应模式重新处理 final 语义。
