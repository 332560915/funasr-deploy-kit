from pydantic import BaseModel


class ASRResponse(BaseModel):
    code: int = 0
    text: str
