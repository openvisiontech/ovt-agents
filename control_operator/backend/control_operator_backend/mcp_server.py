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
        types.Tool(name="get_all_subsystem_abstractions", description="Retrieve all subsystem abstractions.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_asset_access_info", description="Retrieve asset access info.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_asset_control_info", description="Retrieve asset control info.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_state_info", description="Retrieve state info.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_operating_mode_info", description="Retrieve operating mode info.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_status_details", description="Retrieve status details.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_available_agents", description="Retrieve available agents.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_agent_status", description="Retrieve agent status.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_agent_details", description="Retrieve agent details.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_topic_snapshot", description="Retrieve a snapshot of the latest high speed data topic updates.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_data_topic_list", description="Retrieve data topic list.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_data_topic_clients", description="Retrieve data topic clients.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_transform_reporters", description="Retrieve transform reporters.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(name="get_transform_reporters_clients", description="Retrieve transform reporters clients.", inputSchema={"type": "object", "properties": {}}),
        types.Tool(
            name="set_gui_rec",
            description="Set the GUI record.",
            inputSchema={
                "type": "object",
                "properties": {
                    "gui_rec": {
                        "type": "object",
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
                        "type": "object",
                        "description": "The task exec record dict"
                    }
                },
                "required": ["task_exec_rec"]
            }
        ),
    ]

@mcp_server.call_tool()
async def handle_call_tool(name: str, arguments: dict | None) -> list[types.TextContent]:
    ocu = OcuInterface()
    result = ""
    try:
        if name == "get_all_subsystem_abstractions":
            result = await ocu.get_all_subsystem_abstractions()
        elif name == "get_asset_access_info":
            result = await ocu.get_asset_access_info()
        elif name == "get_asset_control_info":
            result = await ocu.get_asset_control_info()
        elif name == "get_state_info":
            result = await ocu.get_state_info()
        elif name == "get_operating_mode_info":
            result = await ocu.get_operating_mode_info()
        elif name == "get_status_details":
            result = await ocu.get_status_details()
        elif name == "get_available_agents":
            result = await ocu.get_available_agents()
        elif name == "get_agent_status":
            result = await ocu.get_agent_status()
        elif name == "get_agent_details":
            result = await ocu.get_agent_details()
        elif name == "get_topic_snapshot":
            topics_data = ocu.get_topic_snapshot()
            result_list = []
            writer = StreamTopicWriter()
            if topics_data and isinstance(topics_data, list):
                for t in topics_data:
                    json_topic = create_json_topic(t)
                    if json_topic is not None:
                        try:
                            binary_data = writer.write(json_topic)
                            b64_string = base64.b64encode(binary_data).decode('utf-8')
                            result_list.append(b64_string)
                        except Exception as e:
                            logger.error(f"Error encoding topic binary: {e}")
            result = json.dumps(result_list)
        elif name == "get_data_topic_list":
            result = await ocu.get_data_topic_list()
        elif name == "get_data_topic_clients":
            result = await ocu.get_data_topic_clients()
        elif name == "get_transform_reporters":
            result = await ocu.get_transform_reporters()
        elif name == "get_transform_reporters_clients":
            result = await ocu.get_transform_reporters_clients()
        elif name == "set_gui_rec":
            if arguments and "gui_rec" in arguments:
                await ocu.set_gui_rec(arguments["gui_rec"])
                result = '{"status": "success"}'
        elif name == "set_task_exec_rec":
            if arguments and "task_exec_rec" in arguments:
                await ocu.set_task_exec_rec(arguments["task_exec_rec"])
                result = '{"status": "success"}'
        else:
            raise ValueError(f"Unknown tool: {name}")

        return [types.TextContent(type="text", text=str(result))]
    except Exception as e:
        logger.error(f"Error executing MCP tool {name}: {e}")
        return [types.TextContent(type="text", text=f"Error: {str(e)}")]
