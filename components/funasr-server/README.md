# FunASR Server 组件

`funasr-server` 是平台的 FunASR websocket 服务端组件，基于官方 FunASR CPU runtime 镜像构建。

## 职责边界

- 运行 FunASR offline websocket ASR 服务。
- 从外置模型目录 `/workspace/models` 加载模型。
- 从外置配置目录 `/workspace/config` 读取启动脚本和热词。
- 在镜像构建时 patch offline server 的 `is_final` 返回值，兼容官方异步客户端。

## 镜像

```text
local/funasr-runtime-sdk-cpu:0.4.7-is-final
```

## 相关文档

- [构建镜像](../../docs/deployment/build.md)
- [配置说明](../../docs/deployment/configuration.md)
- [FunASR final 消息说明](../../docs/reference/funasr-is-final.md)
- [常见问题](../../docs/operations/troubleshooting.md)
