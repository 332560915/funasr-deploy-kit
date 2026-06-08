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

    suffix = os.path.splitext(file.filename or "")[1] or ".audio"
    tmp_path = ""
    total_size = 0
    chunk_size = 1024 * 1024

    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix, dir=temp_dir) as tmp:
        tmp_path = tmp.name

    try:
        async with aiofiles.open(tmp_path, "wb") as tmp:
            while chunk := await file.read(chunk_size):
                total_size += len(chunk)
                if total_size > settings.max_upload_size:
                    raise HTTPException(
                        status_code=413,
                        detail="Uploaded file is too large",
                    )
                await tmp.write(chunk)

        if total_size == 0:
            raise HTTPException(status_code=400, detail="Uploaded file is empty")

        result = await request.app.state.asr_client.recognize_file(tmp_path)
        return ASRResponse(code=0, text=result["text"])
    except FunASRRecognitionError as exc:
        logger.opt(exception=exc).error("ASR processing failed")
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    finally:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
