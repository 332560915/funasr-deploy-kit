import os
from typing import List

from pydantic import Field
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """应用配置。

    配置优先从环境变量读取，容器内也会把 deploy/config/http-api.env 挂载为 .env。
    字段名大小写不敏感，便于 Docker Compose 使用大写环境变量。
    """

    app_name: str = "FunASR HTTP API"
    app_version: str = "1.0.0"
    api_prefix: str = "/api/v1"

    host: str = "0.0.0.0"
    port: int = 8000
    reload: bool = False
    http_api_workers: int = 1
    http_api_limit_concurrency: int = 20
    http_api_limit_max_requests: int = 1000
    http_api_backlog: int = 256
    timeout_keep_alive: int = 360
    request_timeout: float = 360.0

    log_level: str = "INFO"
    log_file: str = "logs/http-api.log"
    log_rotation: str = "100 MB"
    log_retention: str = "14 days"

    cors_origins: List[str] = Field(default_factory=lambda: ["*"])
    cors_allow_credentials: bool = False
    cors_allow_methods: List[str] = Field(default_factory=lambda: ["*"])
    cors_allow_headers: List[str] = Field(default_factory=lambda: ["*"])

    funasr_ws_url: str = "ws://10.2.3.118:10095"
    # 当前 HTTP 文件识别只面向 offline websocket server。
    funasr_mode: str = "offline"
    funasr_audio_fs: int = 16000
    funasr_chunk_size: List[int] = Field(default_factory=lambda: [5, 10, 5])
    funasr_chunk_interval: int = 10
    funasr_use_itn: bool = True
    funasr_hotword: str = ""
    funasr_send_without_sleep: bool = True
    funasr_connect_timeout: float = 10.0
    funasr_final_timeout: float = 30.0
    funasr_close_grace_seconds: float = 0.5
    funasr_max_message_size: int = 10 * 1024 * 1024

    # 业务识别并发，区别于 HTTP 入口并发；用于保护 FunASR Server。
    asr_recognition_concurrency: int = 10

    # 同步接口上传限制。上传文件会先落临时目录，再交给官方客户端识别。
    max_upload_size: int = 100 * 1024 * 1024
    upload_temp_dir: str = "/tmp"

    class Config:
        env_file = os.path.abspath(
            os.path.join(os.path.dirname(__file__), "../../.env")
        )
        env_file_encoding = "utf-8"
        case_sensitive = False


settings = Settings()
