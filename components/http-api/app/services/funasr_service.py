from __future__ import annotations

from pathlib import Path
from typing import Any, Dict

from funasr_client import AsyncFunASRClient, ClientConfig
from loguru import logger

from app.core.config import Settings


class FunASRRecognitionError(RuntimeError):
    """FunASR 未能返回可用识别结果时抛出。"""


class FunASROfflineClient:
    """官方 AsyncFunASRClient 的轻量封装。

    这里不重新实现 websocket 协议，只负责统一配置、错误转换和结果校验。
    """

    def __init__(self, settings: Settings) -> None:
        self.settings = settings
        # mode 由客户端请求传给 FunASR websocket server；当前服务端只推荐 offline。
        self.client = AsyncFunASRClient(
            config=ClientConfig(
                server_url=settings.funasr_ws_url,
                timeout=settings.funasr_final_timeout,
                mode=settings.funasr_mode,
                chunk_size=settings.funasr_chunk_size,
                chunk_interval=settings.funasr_chunk_interval,
                enable_itn=settings.funasr_use_itn,
            )
        )

    async def close(self) -> None:
        await self.client.close()

    async def recognize_file(self, audio_path: str | Path) -> Dict[str, Any]:
        logger.info("FunASR recognition started. audio_path={}", audio_path)
        try:
            result = await self.client.recognize_file(audio_path)
        except Exception as exc:
            raise FunASRRecognitionError(f"FunASR recognition failed: {exc}") from exc

        # 官方客户端返回对象中可能包含更多原始字段；HTTP API 当前只对外暴露 text。
        text = getattr(result, "text", "") or ""
        text = text.strip()
        if not text:
            raise FunASRRecognitionError("FunASR service returned empty result")

        logger.info("FunASR recognition finished. text_length={}", len(text))
        return {"text": text, "raw": result}
