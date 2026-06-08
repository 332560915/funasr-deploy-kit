from contextlib import asynccontextmanager

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
    setup_logging()
    logger.info("Application startup: initializing FunASR client")
    app.state.asr_client = FunASROfflineClient(settings)
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

app.include_router(asr_router, prefix=settings.api_prefix)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=settings.cors_allow_credentials,
    allow_methods=settings.cors_allow_methods,
    allow_headers=settings.cors_allow_headers,
)
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
    )
