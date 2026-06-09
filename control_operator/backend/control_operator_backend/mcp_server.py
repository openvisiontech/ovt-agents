import json
import base64
import logging
import mcp.types as types
from mcp.server import Server

try:
    from uli_py.json_topic import create_json_topic, StreamTopicWriter
except ImportError:
    def create_json_topic(topic): return None
    class StreamTopicWriter:
        def write(self, topic): return b""

from .ocu_interface import OcuInterface

logger = logging.getLogger("mcp_server")

mcp_server = Server("control-operator-backend")

@mcp_server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    return [
        types.Tool(name="get_all_abstractions", description="Retrieve abstractions of all the discovered assets.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_access_info", description="Retrieve the access info of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_control_info", description="Retrieve the control info of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_state_info", description="Retrieve the state info of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_operating_mode_info", description="Retrieve the operating mode info of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_status_details", description="Retrieve the status details of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_agent_list", description="Retrieve the list of the available agents of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_agent_status", description="Retrieve the list of the status of the available agents of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_agent_details", description="Retrieve the list of the details of the available agents of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_data_topic_list", description="Retrieve list of available data topics of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_schema_list", description="Retrieve list of schemas of the available data topics of the selected asset", inputSchema={"type": "object", "properties":{}}),
        types.Tool(name="get_data_topic_clients", description="Retrieve list of the clients that subscribe the available data topics of the selected asset .", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_transform_reporters", description="Retrieve list of the transform reporters of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_transform_clients", description="Retrieve list of clients that receive transform reports from the transform reporters of the selected asset.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(
            name="set_gui_rec",
            description="Set the GUI record.",
            inputSchema={
                "type": "object",
                "properties": {
                    "gui_rec": {
                        "type": "dict",
                        "description": "The GUI record dict"
                    }
                },
                "required": ["gui_rec"]
            }
        ),
        types.Tool(
            name="set_task_exec_rec",
            description="Set the Task Exec record.",
            inputSchema={
                "type": "object",
                "properties": {
                    "task_exec_rec": {
                        "type": "dict",
                        "description": "The task exec record dict"
                    }
                },
                "required": ["task_exec_rec"]
            }
        ),
        types.Tool(
            name="set_task_control_rec",
            description="Set the task control record.",
            inputSchema={
                "type": "object",
                "properties": {
                    "task_control_rec": {
                        "type": "dict",
                        "description": "The task control record dict"
                    }
                },
                "required": ["task_control_rec"]
            }
        ),
    ]

@mcp_server.call_tool()
async def handle_call_tool(name: str, arguments: dict | None) -> list[types.TextContent]:
    ocu = OcuInterface()
    result = ""
    try:
        if name == "get_all_abstractions":
            result = await ocu.get_all_abstractions()
        elif name == "get_access_info":
            result = await ocu.get_access_info()
        elif name == "get_control_info":
            result = await ocu.get_control_info()
        elif name == "get_state_info":
            result = await ocu.get_state_info()
        elif name == "get_operating_mode_info":
            result = await ocu.get_operating_mode_info()
        elif name == "get_status_details":
            result = await ocu.get_status_details()
        elif name == "get_agent_list":
            result = await ocu.get_agent_list()
        elif name == "get_agent_status":
            result = await ocu.get_agent_status()
        elif name == "get_agent_details":
            result = await ocu.get_agent_details()
        elif name == "get_data_topic_list":
            result = await ocu.get_data_topic_list()
        elif name == "get_schema_list":
            result = await ocu.get_schema_list()
        elif name == "get_data_topic_clients":
            result = await ocu.get_data_topic_clients()
        elif name == "get_transform_reporters":
            result = await ocu.get_transform_reporters()
        elif name == "get_transform_clients":
            result = await ocu.get_transform_clients()
        elif name == "set_gui_rec":
            if arguments and "gui_rec" in arguments:
                await ocu.set_gui_rec(arguments["gui_rec"])
                result = '{"status": "success"}'
        elif name == "set_task_exec_rec":
            if arguments and "task_exec_rec" in arguments:
                await ocu.set_task_exec_rec(arguments["task_exec_rec"])
                result = '{"status": "success"}'
        elif name == "set_task_control_rec":
            if arguments and "task_control_rec" in arguments:
                await ocu.set_task_control_rec(arguments["task_control_rec"])
                result = '{"status": "success"}'
        else:
            raise ValueError(f"Unknown tool: {name}")

        return [types.TextContent(type="text", text=str(result))]
    except Exception as e:
        logger.error(f"Error executing MCP tool {name}: {e}")
        return [types.TextContent(type="text", text=f"Error: {str(e)}")]
