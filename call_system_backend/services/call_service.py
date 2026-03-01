from utils.logger import log_call

class CallService:

    @staticmethod
    def process_call(data: dict):
        caller = data.get("From", "Unknown")

        log_call(f"Incoming call from {caller}")

        return {
            "status": "success",
            "caller": caller,
            "message": "Call received successfully"
        }