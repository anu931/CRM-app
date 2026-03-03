from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()

connected_clients: list[WebSocket] = []

# In-memory call log (persists while server runs)
call_log_entries: list[dict] = []


@router.websocket("/ws/call")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected_clients.append(websocket)
    print("Client connected")
    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        connected_clients.remove(websocket)
        print("Client disconnected")

#for testing manual triggering of incoming call from backend 
@router.get("/trigger-call")
async def trigger_call():
    for client in connected_clients:
        await client.send_text("incoming_call:Customer:+91 9990000888")
    return {"sent_to": len(connected_clients)}

#for json schema of incoming call data
class CallInfo(BaseModel):
    name: str
    number: str
    message: str = ""


@router.post("/incoming-call")
async def incoming_call(data: CallInfo):
    """
    Trigger incoming call on Flutter + save to call log.

    curl -X POST http://127.0.0.1:8000/incoming-call \
         -H "Content-Type: application/json" \
         -d '{"name": "John", "number": "+91 9876543210", "message": "Billing issue"}'
    """
    now = datetime.now()
    date_str = now.strftime("%d-%m-%y")
    time_str = now.strftime("%H:%M")

    # Save to server-side call log
    call_log_entries.insert(0, {
        "name": data.name,
        "number": data.number,
        "message": data.message,
        "date": date_str,
        "time": time_str,
    })

    # Push incoming call + log entry to Flutter via WebSocket
    # Format: incoming_call:name:number:message:date:time
    msg = f"incoming_call:{data.name}:{data.number}:{data.message}:{date_str}:{time_str}"

    disconnected = []
    for client in connected_clients:
        try:
            await client.send_text(msg)
        except Exception:
            disconnected.append(client)
    for d in disconnected:
        connected_clients.remove(d)

    return {"status": "sent", "sent_to": len(connected_clients)}

@router.get("/call-log")
async def get_call_log():
    return {"entries": call_log_entries}
class TranscriptLine(BaseModel):
    speaker: str
    text: str

@router.post("/send-transcript")
async def send_transcript(data: TranscriptLine):
    message = f"transcript:{data.speaker}:{data.text}"
    disconnected = []
    for client in connected_clients:
        try:
            await client.send_text(message)
        except Exception:
            disconnected.append(client)
    for d in disconnected:
        connected_clients.remove(d)
    return {"sent_to": len(connected_clients)}