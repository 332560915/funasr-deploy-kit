import sys

from loguru import logger

from app.core.config import settings


def setup_logging() -> None:
    # 移除 loguru 默认 sink，统一输出到 stdout 和挂载日志文件。
    logger.remove()
    logger.add(
        sys.stdout,
        level=settings.log_level,
        enqueue=True,
        backtrace=False,
        diagnose=False,
    )
    logger.add(
        # 日志文件目录由 Compose 挂载到宿主机，便于离线环境排障。
        settings.log_file,
        level=settings.log_level,
        rotation=settings.log_rotation,
        retention=settings.log_retention,
        encoding="utf-8",
        enqueue=True,
        backtrace=False,
        diagnose=False,
    )
