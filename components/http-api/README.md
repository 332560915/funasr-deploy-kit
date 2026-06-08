# HTTP API 组件

`http-api` 是平台的文件上传式 HTTP API 组件，负责接收音频或视频文件、写入临时目录、调用 FunASR Server，并返回识别文本。

## 职责边界

- 提供 `POST /api/v1/asr` 文件识别接口。
- 提供 Swagger 文档页面，默认路径为 `/docs`。
- 管理上传文件大小限制和临时文件清理。
- 使用官方 `funasr-python` `AsyncFunASRClient` 调用 FunASR websocket 服务。
- 输出 loguru 日志到容器内 `/app/logs`。

## 本地开发

```bash
uv sync
uv run uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## 相关文档

- [HTTP API 调用](../../docs/zh/usage/api.md)
- [配置说明](../../docs/zh/deployment/configuration.md)
- [构建镜像](../../docs/zh/deployment/build.md)
- [更新维护](../../docs/zh/operations/update.md)
