# Control Operator Backend

This module houses the backend server for the Control Operator, built dynamically leveraging the FastAPI framework, `aiortc` for WebRTC communication, and the ULI SDK native Python wrap APIs (`pybinds.uli_py`).

## Implementation Outline

The backend is modularized into several core specialized Python files:

-   **`main.py`**: 
    The main FastAPI application entry point. It hosts the startup/shutdown processes (lifespan manager), starts essential background tasks (`ocu_topic_distribution_task`, `agent_response_distribution_task`), and provides the `/ws/rtc` WebSocket signaling hub endpoint for orchestrating WebRTC connections.
-   **`webrtc_connection.py`**:
    Handles multiplexed data channels per active client connection, ensuring segregated async queues and tasks for incoming streams (`stream_channel` for telemetry or media data) and text JSON logic (`chat_channel` for WebRTC JSON instructions). 
-   **`ocu_interface.py`**:
    A singleton layer that interfaces directly with the `Ocu` wrapper class via `get_data` and `set_data` URL payloads. It masks ULI SDK complexities by providing descriptive async abstraction endpoints (e.g., `get_all_control_abstractions`, `get_status_details`).
-   **`agent_handler.py`**:
    Scaffolds the architecture for executing prompts processed via the LangChain DeepAgent framework.
-   **`config.json` & `config.py`**:
    Serves and validates default behavioral constants inside the application environment.

## Configurations (`config.json`)

`config.json` drives runtime arguments instantiated during startup. Below are the basic structures to be provided:

```json
{
  "working_dir": ".",
  "expiration_time": 10.0,
  "render_interval": 0.1,
  "agent_config": {
    "model": "default",
    "claude_api_key": "YOUR_CLAUDE_API_KEY",
    "gemini_api_key": "YOUR_GEMINI_API_KEY",
    "openai_api_key": "YOUR_OPENAI_API_KEY"
  }
}
```

-   **`working_dir`**: Default system working directory targeting DataViewer implementations. Relative paths (like `.`) indicate the current process directory.
-   **`expiration_time`**: Defines (in seconds) the expiration window for cached system data topics.
-   **`render_interval`**: Modifies the visual loop tick latency configurations rendering assets downstream.
-   **`agent_config.model`**: Specifies the initial target AI model configurations for DeepAgent integration logic.
-   **`agent_config.claude_api_key`**: API key to authenticate with Anthropic services for Claude models.
-   **`agent_config.gemini_api_key`**: API key to authenticate with Google services for Gemini models.
-   **`agent_config.openai_api_key`**: API key to authenticate with OpenAI services for ChatGPT models.

## How to Run

Ensure that your environment activates any specific PyBind environments and installs prerequisites (`uv`, FastAPI, aiortc, etc).

To launch the server locally for development with hot-reloading:

```bash
uvicorn control_operator.backend.main:app --host 0.0.0.0 --port 8080 --reload
```

The WebRTC Signalling Server will become available at:
`ws://localhost:8080/ws/rtc`
