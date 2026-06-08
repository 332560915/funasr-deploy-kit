import anyio
from loguru import logger
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse


class TimeoutMiddleware(BaseHTTPMiddleware):
    """Request timeout middleware."""

    def __init__(self, app, timeout: float = 360.0) -> None:
        super().__init__(app)
        self.timeout = timeout

    async def dispatch(self, request: Request, call_next):
        try:
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
