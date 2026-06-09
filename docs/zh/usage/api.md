# HTTP API 调用

HTTP API 组件提供文件上传式语音识别接口。调用方不需要预处理音频或视频文件。

当前接口是同步接口，适合短音频、功能验证和 Swagger 联调。

## Swagger

服务启动后打开：

```text
http://127.0.0.1:18000/docs
```

部署在服务器时，把主机改为服务器 IP：

```text
http://10.2.3.118:18000/docs
```

## 健康检查

```bash
curl http://127.0.0.1:18000/health
```

示例返回：

```json
{
  "status": "healthy"
}
```

## 识别接口

```text
POST /api/v1/asr
```

请求字段：

```text
file  音频或视频文件
```

请求示例：

```bash
curl -F "file=@/path/to/audio-or-video.mp4" http://127.0.0.1:18000/api/v1/asr
```

示例返回：

```json
{
  "code": 0,
  "text": "识别文本"
}
```

## 服务信息

```bash
curl http://127.0.0.1:18000/
```

该接口返回服务名称、版本和主要端点。

## 上传限制

上传大小由 `MAX_UPLOAD_SIZE` 控制，默认：

```env
MAX_UPLOAD_SIZE=31457280
```

即 30MB。超过限制时返回 `413`。

配置位置：

```text
/data/funasr/runtime/config/http-api.env
```

修改后生效：

```bash
bash scripts/update.sh config /data/funasr
```
