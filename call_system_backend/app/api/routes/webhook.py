from fastapi import APIRouter, Form
from app.usecases.call_usecase import CallUseCase
from app.schemas.call_schema import CallResponse

router = APIRouter(prefix="/webhook", tags=["Webhook"])

@router.post("/incoming-call", response_model=CallResponse)
async def incoming_call(
    From: str = Form(...),
    To: str = Form(None),
    CallSid: str = Form(None)
):
    data = {
        "From": From,
        "To": To,
        "CallSid": CallSid
    }

    usecase = CallUseCase()
    result = usecase.handle_incoming_call(data)
    return result