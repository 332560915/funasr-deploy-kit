# FunASR Server 组件

`funasr-server` 是平台的 FunASR websocket 服务端组件，基于官方 FunASR CPU runtime 镜像构建。

## 职责边界

- 运行 FunASR offline websocket ASR 服务。
- 从外置模型目录 `/workspace/models` 加载模型。
- 镜像内置启动脚本 `start-funasr.sh`，从环境变量读取模型、线程、SSL 等启动参数。
- 从外置配置目录 `/workspace/config` 读取热词等运行配置。
- 维护 `src/websocket-server.cpp`，只调整 offline 最终响应的 `is_final` 返回值，兼容官方异步客户端。

## 源码修改

`src/websocket-server.cpp` 来自官方 FunASR runtime 的 `runtime/websocket/bin/websocket-server.cpp`。本项目在 offline 最终响应位置补充 `is_final` 返回值，便于兼容官方异步客户端。

## 镜像

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## 相关文档

- [镜像构建说明](../../docs/zh/deployment/build.md)
- [配置说明](../../docs/zh/deployment/configuration.md)
- [FunASR final 消息说明](../../docs/zh/reference/funasr-is-final.md)
- [常见问题](../../docs/zh/operations/troubleshooting.md)
