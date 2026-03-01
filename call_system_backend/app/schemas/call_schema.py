from pydantic import BaseModel

class CallResponse(BaseModel):
    status: str
    caller: str
    message: str