import anyio
from loguru import logger
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse


class TimeoutMiddleware(BaseHTTPMiddleware):
    """HTTP 请求整体超时中间件。

    ASR 同步识别会占用较长请求时间，但仍需要上限，避免客户端断开或服务端异常时无限等待。
    """

    def __init__(self, app, timeout: float = 360.0) -> None:
        super().__init__(app)
        self.timeout = timeout

    async def dispatch(self, request: Request, call_next):
        try:
            # anyio.fail_after 会在超时后取消下游处理并返回 504。
            with anyio.fail_after(self.timeout):
                return await call_next(request)
        except TimeoutError as exc:
            logger.opt(exception=exc).warning("Request timed out. Url: {}", request.url)
            return JSONResponse(
                status_code=504,
                content={
                    "error": True,
                    "message": "Request timeout",
                    "status_code": 504,
                },
            )
