# HTTP API 调用

HTTP API 组件提供文件上传式语音识别接口。调用方不需要预处理音频或视频文件。

## Swagger 文档

HTTP API 内置 Swagger 文档，服务启动后可以直接在浏览器中打开：

```text
http://127.0.0.1:18000/docs
```

如果部署在服务器上，将地址中的主机替换为服务器 IP：

```text
http://10.2.3.118:18000/docs
```

可以在 Swagger 页面中选择 `/api/v1/asr` 接口，上传文件并直接测试识别结果。

## 识别接口

```text
POST /api/v1/asr
```

请求示例：

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

返回示例：

```json
{
  "code": 0,
  "text": "识别文本"
}
```

## 健康检查

```bash
curl http://127.0.0.1:18000/health
```

返回：

```json
{
  "status": "healthy"
}
```

## 服务信息

```bash
curl http://127.0.0.1:18000/
```

该接口返回服务名称、版本和主要端点。

## 上传限制

上传大小由 `MAX_UPLOAD_SIZE` 控制，默认样例为 `524288000`，即 500MB。HTTP API 会分块写入临时文件，超过限制时返回 `413`。
