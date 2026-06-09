# Control Operator Backend

This module houses the backend server for the Control Operator, built dynamically leveraging the FastAPI framework, `aiortc` for WebRTC communication, and the ULI SDK native Python wrap APIs (`pybinds.uli_py`).

## 1. Implementation Outline

The backend is modularized into several core specialized Python files:

-   **`main.py`**: 
    The main FastAPI application entry point. It hosts the startup/shutdown processes (lifespan manager), starts essential background tasks (`ocu_topic_distribution_task`, `agent_response_distribution_task`), and provides the `/ws/rtc` WebSocket signaling hub endpoint for orchestrating WebRTC connections.
-   **`webrtc_connection.py`**:
    Handles multiplexed data channels per active client connection, ensuring segregated async queues and tasks for incoming streams (`stream_channel` for telemetry or media data) and text JSON logic (`chat_channel` for WebRTC JSON instructions). 
-   **`ocu_interface.py`**:
    A singleton layer that interfaces directly with the `Ocu` wrapper class via `get_data` and `set_data` URL payloads. It masks ULI SDK complexities by providing descriptive async abstraction endpoints (e.g., `get_all_asset_abstractions`, `get_status_details`).
-   **`agent_handler.py`**:
    Scaffolds the architecture for executing prompts processed via the LangChain DeepAgent framework.
-   **`mcp_server.py`**:
    Exposes the system capabilities of the `OcuInterface` securely via the Model Context Protocol (MCP). Features mappings for getter and setter operations to integrate directly with external AI agents.
-   **`config.json` & `config.py`**:
    Serves and validates default behavioral constants inside the application environment.

## 2. Configurations (`config.json`)

`config.json` drives runtime arguments instantiated during startup. Below are the basic structures to be provided:

```json
{
  "working_dir": ".",
  "agent_config": {
    "model": "default",
    "claude_api_key": "YOUR_CLAUDE_API_KEY",
    "gemini_api_key": "YOUR_GEMINI_API_KEY",
    "openai_api_key": "YOUR_OPENAI_API_KEY"
  }
}
```

-   **`working_dir`**: Default system working directory targeting DataViewer implementations. Relative paths (like `.`) indicate the current process directory.
-   **`agent_config.model`**: Specifies the initial target AI model configurations for DeepAgent integration logic.
-   **`agent_config.claude_api_key`**: API key to authenticate with Anthropic services for Claude models.
-   **`agent_config.gemini_api_key`**: API key to authenticate with Google services for Gemini models.
-   **`agent_config.openai_api_key`**: API key to authenticate with OpenAI services for ChatGPT models.

## 3. Prerequisites
- Python 3.10
- uv
- FastAPI
- aiortc
- uli_py

Follow the instructions below to build and deploy uli_py:

```bash
cd ../uli_sdk

# Build the pybinds
./build/pkg_build.sh -d x86_64 -p //pybinds/uli_py:uli_py-pkg
./build/pkg_stage.sh -d x86_64 --clean
./build/pkg_stage.sh -d x86_64 //pybinds/uli_py:uli_py-pkg
./build/pkg_deploy.sh -d x86_64 -h localhost --deploy_path uli_deploy/pybinds/uli_py
```

## 4. Installation

The backend is packaged as a standard Python module using `pyproject.toml`. You can install it locally using `pip` or `uv` to automatically satisfy all Python dependencies:

```bash
cd /home/ovt/develop/ovt-agents/control_operator/backend
uv pip install -e .
# Or simply pip install -e .
```

## 5. How to Run

After installation, the `control-operator-backend` CLI command is automatically registered in your environment. You can launch the backend webserver from anywhere in the filesystem:

```bash
export PYTHONPATH=/home/ovt/uli_deploy/pybinds:$PYTHONPATH
control-operator-backend
```

Alternatively, you can just run the `start_backend.sh` script located in the `scripts` directory of the overarching `control_operator` project root which wraps this functionality!

```bash
cd /home/ovt/develop/ovt-agents/control_operator
./scripts/start_backend.sh
```

The WebRTC Signalling Server will become available at:
`ws://localhost:8080/ws/rtc`

## 6. MCP Server Integration

The backend features a fully integrated [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server. This exposes the native `OcuInterface` capabilities directly to connected AI Agents via HTTP SSE transport. 

### Connecting an MCP Client

When the backend runs on port `8080`, the MCP SSE endpoint becomes automatically available.

To connect an AI Agent (e.g., Claude Desktop, or a custom agent SDK):
1. Configure your agent's MCP client to establish an SSE (Server-Sent Events) connection over HTTP.
2. Direct the agent to the base SSE URL: `http://localhost:8080/mcp/sse`

The MCP endpoints natively mounted onto the backend are:
- `GET /mcp/sse`: The primary streaming endpoint for Server-Sent Events.
- `POST /mcp/messages`: The HTTP transport endpoint where the client posts JSON-RPC messages to the server.
