from fastapi import APIRouter, WebSocket, WebSocketDisconnect

router = APIRouter()

connected_clients = []

# ✅ FIXED: was "/ws", now matches Flutter's "ws://192.168.1.6:8000/ws/call"
@router.websocket("/ws/call")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected_clients.append(websocket)
    print("Client connected")

    try:
        while True:
            data = await websocket.receive_text()
            print("Received:", data)
            await websocket.send_text(f"Server got: {data}")

    except WebSocketDisconnect:
        connected_clients.remove(websocket)
        print("Client disconnected")

@router.get("/trigger-call")
async def trigger_call():
    """Hit this URL in your browser to simulate an incoming call on the app."""
    for client in connected_clients:
        await client.send_text("incoming_call")
    return {"sent_to": len(connected_clients), "clients": "agents"}