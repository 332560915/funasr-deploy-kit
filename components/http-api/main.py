from contextlib import asynccontextmanager
import asyncio

import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from loguru import logger

from app.api import asr_router
from app.core.config import settings
from app.core.logging import setup_logging
from app.core.middlewares import TimeoutMiddleware
from app.services.funasr_service import FunASROfflineClient


@asynccontextmanager
async def lifespan(app: FastAPI):
    # 应用生命周期内只创建一个 FunASR 官方异步客户端，避免每次请求重复建连。
    setup_logging()
    logger.info("Application startup: initializing FunASR client")
    app.state.asr_client = FunASROfflineClient(settings)

    # HTTP 并发和识别并发分开控制：HTTP 可以接入更多请求，真正进入识别的请求在这里限流。
    app.state.asr_semaphore = asyncio.Semaphore(settings.asr_recognition_concurrency)
    try:
        yield
    finally:
        await app.state.asr_client.close()
        logger.info("Application shutdown")


app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    docs_url="/docs",
    lifespan=lifespan,
)

# 业务接口统一挂载到配置的 API 前缀，默认 /api/v1。
app.include_router(asr_router, prefix=settings.api_prefix)

# 默认允许跨域，方便 Swagger、本地页面或其他系统直接联调；生产可通过环境变量收紧。
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=settings.cors_allow_credentials,
    allow_methods=settings.cors_allow_methods,
    allow_headers=settings.cors_allow_headers,
)

# 同步识别接口可能耗时较长，但仍需要整体超时保护，避免请求无限挂起。
app.add_middleware(TimeoutMiddleware, timeout=settings.request_timeout)


@app.get("/")
async def root():
    return {
        "message": settings.app_name,
        "version": settings.app_version,
        "endpoints": {
            "asr": f"{settings.api_prefix}/asr",
            "health": "/health",
        },
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy"}


@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc: HTTPException):
    # 业务异常保持统一 JSON 结构，便于调用方处理错误。
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": True,
            "message": exc.detail,
            "status_code": exc.status_code,
        },
    )


@app.exception_handler(Exception)
async def general_exception_handler(request, exc: Exception):
    # 未预期异常只向客户端返回通用信息，详细堆栈写入日志。
    logger.opt(exception=exc).error("Unhandled exception")
    return JSONResponse(
        status_code=500,
        content={
            "error": True,
            "message": "Internal server error",
            "status_code": 500,
        },
    )


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.reload,
        log_level=settings.log_level.lower(),
        timeout_keep_alive=settings.timeout_keep_alive,
        workers=settings.http_api_workers,
        limit_concurrency=settings.http_api_limit_concurrency,
        limit_max_requests=settings.http_api_limit_max_requests,
        backlog=settings.http_api_backlog,
    )
