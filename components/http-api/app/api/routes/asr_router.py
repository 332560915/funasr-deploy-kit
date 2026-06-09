import os
import tempfile
from pathlib import Path

import aiofiles
from fastapi import APIRouter, File, HTTPException, Request, UploadFile
from loguru import logger

from app.core.config import settings
from app.models.response_models import ASRResponse
from app.services.funasr_service import FunASRRecognitionError

router = APIRouter(tags=["ASR"])


@router.post("/asr", response_model=ASRResponse)
async def recognize(request: Request, file: UploadFile = File(...)):
    temp_dir = Path(settings.upload_temp_dir)
    temp_dir.mkdir(parents=True, exist_ok=True)

    # 保留原文件后缀，方便底层音频处理库根据扩展名识别容器格式。
    suffix = os.path.splitext(file.filename or "")[1] or ".audio"
    tmp_path = ""
    total_size = 0
    chunk_size = 1024 * 1024

    # 使用 delete=False 是为了把文件路径交给 FunASR 官方客户端；finally 中统一清理。
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix, dir=temp_dir) as tmp:
        tmp_path = tmp.name

    try:
        async with aiofiles.open(tmp_path, "wb") as tmp:
            while chunk := await file.read(chunk_size):
                total_size += len(chunk)
                # 分块写入时累计大小，超过限制立刻拒绝，避免大文件占满临时目录。
                if total_size > settings.max_upload_size:
                    raise HTTPException(
                        status_code=413,
                        detail="Uploaded file is too large",
                    )
                await tmp.write(chunk)

        if total_size == 0:
            raise HTTPException(status_code=400, detail="Uploaded file is empty")

        # 识别属于重资源操作，使用应用级信号量控制真正进入 FunASR 的并发量。
        async with request.app.state.asr_semaphore:
            result = await request.app.state.asr_client.recognize_file(tmp_path)
        return ASRResponse(code=0, text=result["text"])
    except FunASRRecognitionError as exc:
        logger.opt(exception=exc).error("ASR processing failed")
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    finally:
        # 无论识别成功、失败或超限，都清理临时上传文件。
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
