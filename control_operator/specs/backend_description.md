# Control Operator Backend Description

## Overview
The Control Operator backend is a modular, high-performance service built using FastAPI, AIORTC (WebRTC), and Python wrappers over the ULI SDK (PyBinds). Its primary responsibility is managing the WebSocket signaling endpoint and negotiating WebRTC PeerConnections to enable low-latency, bidirectional, multi-channel communication (JSON Chat & Binary Streams) with web clients.

## Directory Structure
- `main.py`: The entrypoint of the FastAPI backend application.
- `webrtc_connection.py`: Manages WebRTC negotiation, ICE signaling, and custom data channels.
- `ocu_interface.py`: Handles interactions with the native C++ ULI SDK (Ocu).
- `agent_handler.py`: Wraps integration capabilities for the LangChain DeepAgent framework.
- `config.py` / `config.json`: Handles application bootstrapping parameters including API keys.

## Component Integrations

### 1. The Signalling Server & `main.py`
`main.py` leverages FastAPI to host the WebRTC signaling layer:
- **Endpoint**: `/ws/rtc` receives `offer` and `candidate` payloads via WebSockets.
- **FastAPI Lifespan**: Sets up background context. Upon startup:
  - Validates environments via `config.json`.
  - Instantiates `Ocu`, the C++ native abstraction mapping.
  - Generates parallel async tasks: `ocu_topic_distribution_task` and `agent_response_distribution_task` allowing the server to broadcast ULI topics to all active peer connections seamlessly.

### 2. WebRTC Sessions & `webrtc_connection.py`
Every WebSocket client establishing an SDP offer spawns a new instance of `WebRTCConnection`.
- **PeerConnection (AIORTC)**: Uses an event-driven mechanism to attach local answers.
- **Multiplexed Datachannels**:
  - `chat_channel`: Exchanges reliable string-based serialized JSON. It natively unmarshals actions (`get_asset_access_info`, etc.) and delegates appropriately to `ocu_interface.py`.
  - `stream_channel`: High-throughput binary ingestion reserved for future topics forwarding (e.g. 3-D meshes or byte-arrays).
- **Isolation Tasks**: 
  - Runs `process_chat_queue` and `process_stream_queue` independent of `process_topic_queue` ensuring real-time messages are not bottlenecked by heavy binary allocations.
  - `process_chat_queue` handles the chat messages from the frontend and sends them to the `ocu_interface.py` for processing.
  - `process_stream_queue` handles the stream messages from the frontend and sends them to the agent handler for processing.
  - `process_topic_queue` handles the topic messages from the `ocu_topic_distribution_task` and sends them to the frontend.

### 3. Interface Layer (`ocu_interface.py`)
Provides an asynchronous Singleton interface over the `Ocu` bindings. 
Instead of clients needing to know the complex specific `data://` URI taxonomy of typical ULI operations, the class dynamically formats payloads:
- Dynamically assigns context like `cls.domain` avoiding magic strings.
- Implements async request handlers (e.g., `set_joystick`, `set_gui_rec`, `get_all_control_abstractions`) ensuring the FastAPI async loop remains unblocked during heavy SDK queries.

### 4. Agent Handler (`agent_handler.py`)
Serves as the foundation for the DeepAgent ecosystem.
It abstracts Langchain initializations and model definitions inside `initialize()`, establishing the scaffolding required to interpret requests like `user_prompt` routed directly from the active connection's `chat_channel`. Uses configurations from `config.json` containing specific model API keys (Claude, Gemini, OpenAI).

## Execution Flow summary
1. Startup: Uvicorn engages `lifespan` > Initializing ULI SDK applications (Ocu & DataViewer) & Langchain instances > Global distribution queues started.
2. Handshake: Client connects to `/ws/rtc` WebSocket > Sends SDP Offer > `WebRTCConnection` handles answer and parses candidates.
3. Chat Action: Client fires JSON Action over DataChannel (`chat_channel`). -> Put in AsyncQueue -> Picked up by `process_chat_queue`.
4. Logic Delegation: 
   - Non-inference inputs route to `OcuInterface` and return via SDK queries.
   - Inference inputs (`user_prompt`) route to `DeepAgentHandler`.
5. Topic Broadcasting: The global `ocu_topic_distribution_task` concurrently retrieves new native SDK topics, cloning them into each active client's `topic_queue` ensuring synchronization down to the web frontend instance.
