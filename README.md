# 📞 Call Agent CRM App

A cross-platform **Call Handling CRM Application** built with **Flutter (frontend)** and **FastAPI (backend)** that allows agents to receive calls, record conversations, and store call logs locally for customer problem identification.

The system uses **ngrok** to expose the backend server publicly so the mobile app can communicate with it from any network.

---

## 🚀 Features

* Incoming call interface
* Accept / Reject calls
* Real-time call screen
* Audio recording
* Local file storage
* Call logs tracking
* FastAPI backend integration
* Public API access using ngrok
* Clean architecture backend structure

---

## 🧠 Tech Stack

### Frontend

* Flutter
* Dart
* Material UI

### Backend

* FastAPI (Python)
* Uvicorn server
* REST APIs
* Webhooks

### Networking

* ngrok (public tunnel for local backend)

### Storage

* Local device storage for recordings
* Local structured logs

---

## 🏗 Project Architecture

```
Flutter App
     │
     │ HTTP / WebSocket
     ▼
ngrok Public URL
     │
     ▼
FastAPI Backend
     │
     ▼
Local Storage
```

---

## 📂 Project Structure

```
CALL_AGENT_APP/
│
├── android/
├── ios/
├── build/
│
├── lib/                     # Flutter frontend
│   ├── main.dart
│   ├── incoming_call.dart
│   ├── active_call.dart
│   └── call_log.dart
│
├── call_system_backend/     # FastAPI backend
│   │
│   ├── app/
│   │   ├── api/
│   │   │   └── routes/
│   │   │       ├── route.py
│   │   │       └── webhook.py
│   │   │
│   │   ├── core/
│   │   │   └── config.py
│   │   │
│   │   ├── schemas/
│   │   │
│   │   ├── services/
│   │   │   └── call_service.py
│   │   │
│   │   ├── usecases/
│   │   │   └── call_usecase.py
│   │   │
│   │   └── utils/
│   │       └── logger.py
│   │
│   ├── main.py
│   ├── requirements.txt
│   └── venv/
│
└── README.md
```

---

## 🧩 Backend Architecture Explanation

Your backend follows **Clean Architecture principles**:

### Routes Layer

Handles API endpoints
`routes/route.py` → API endpoints
`routes/webhook.py` → webhook listener

---

### Usecase Layer

Business logic controller
`call_usecase.py`

* controls call workflow
* processes requests
* coordinates services

---

### Service Layer

Handles operations
`call_service.py`

* manages call handling logic
* recording logic
* data handling

---

### Core Layer

Configuration settings
`config.py`

---

### Utils Layer

Utility helpers
`logger.py` → logging system

---

## ⚙️ Installation Guide

### 1️⃣ Clone Repo

```
git clone https://github.com/anu931/CRM-app.git
cd CRM-app
```

---

### 2️⃣ Run Backend

```
cd call_system_backend
pip install -r requirements.txt
uvicorn main:app --reload
```

Runs locally at:

```
http://127.0.0.1:8000
```

---

### 3️⃣ Start ngrok Tunnel

```
ngrok http 8000
```

Copy generated public URL and use it inside Flutter API base URL.

Example:

```
https://abcd1234.ngrok.io
```

---

### 4️⃣ Run Flutter App

```
flutter pub get
flutter run
```

---

## 🔁 Call Flow Logic

```
Incoming call request → Backend API
        ↓
Flutter receives event
        ↓
Incoming call screen appears
        ↓
Agent accepts
        ↓
Recording starts
        ↓
Audio stored locally
        ↓
Call log saved
        ↓
Call ends
```

---

## 📊 System Design Pattern

Backend follows:

Clean Architecture + Layered Pattern

Benefits:

* modular code
* easy testing
* scalable backend
* maintainable logic

---

## 🔮 Future Enhancements

* Cloud database
* Agent authentication
* Admin dashboard
* Analytics
* AI speech analysis
* Call sentiment detection

---

⭐ Star this repo if you like it!
