import sys

from loguru import logger

from app.core.config import settings


def setup_logging() -> None:
    logger.remove()
    logger.add(
        sys.stdout,
        level=settings.log_level,
        enqueue=True,
        backtrace=False,
        diagnose=False,
    )
    logger.add(
        settings.log_file,
        level=settings.log_level,
        rotation=settings.log_rotation,
        retention=settings.log_retention,
        encoding="utf-8",
        enqueue=True,
        backtrace=False,
        diagnose=False,
    )
