from app.services.call_service import CallService

class CallUseCase:
    def __init__(self):
        self.service = CallService()

    def handle_incoming_call(self, data: dict):
        return self.service.process_call(data)