from pydantic import BaseModel


class ASRResponse(BaseModel):
    """文件识别接口的稳定返回结构。"""

    code: int = 0
    text: str
