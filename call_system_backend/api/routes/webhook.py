from fastapi import APIRouter, Form
from services.call_service import CallService
from schemas.call_schema import CallResponse

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
    return CallService.process_call(data)