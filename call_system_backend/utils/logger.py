from datetime import datetime

def log_call(message: str):
    time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{time}] {message}")