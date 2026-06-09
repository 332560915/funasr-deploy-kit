# FunASR Server 组件

`funasr-server` 是平台的 FunASR websocket 服务端组件，基于官方 FunASR CPU runtime 镜像构建。

## 职责边界

- 运行 FunASR offline websocket ASR 服务。
- 从外置模型目录 `/workspace/models` 加载模型。
- 从外置配置目录 `/workspace/config` 读取启动脚本和热词。
- 维护 `src/websocket-server.cpp` 官方源码基线，便于后续通过 Git 追踪兼容修改。

## 源码修改

`src/websocket-server.cpp` 来自官方 FunASR runtime 的 `runtime/websocket/bin/websocket-server.cpp`。本项目不再使用 Dockerfile 中的 `sed` 全局替换。当前文件保持官方源码，后续如需修改 offline 最终响应，会直接在该源码文件中提交明确差异。

## 镜像

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## 相关文档

- [构建镜像](../../docs/zh/deployment/build.md)
- [配置说明](../../docs/zh/deployment/configuration.md)
- [FunASR final 消息说明](../../docs/zh/reference/funasr-is-final.md)
- [常见问题](../../docs/zh/operations/troubleshooting.md)
