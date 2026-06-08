# 版本变更记录

本文记录 FunASR 语音识别平台的重要变更。

当前项目尚未正式发布。后续只有在明确新增发布版本或重要变更时，再追加新的记录。

## [0.1.0] - 2026-06-08

### 初始版本

- 提供 FunASR Server 容器化部署，基于官方 FunASR CPU runtime 镜像构建。
- 提供文件上传式 HTTP API，支持上传音频或视频文件并返回识别文本。
- HTTP API 使用官方 `funasr-python` `AsyncFunASRClient` 调用 FunASR websocket 服务。
- 提供在线构建、Compose 启动、离线打包和离线部署能力。
- 支持配置、热词、模型、日志和临时目录外置挂载。
- 对 FunASR offline websocket server 做 `is_final=true` 补丁，兼容官方异步客户端。
- 提供中文文档、Swagger 测试入口和版本变更记录。
