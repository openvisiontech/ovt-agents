'''
Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
All rights reserved.

Open Vision Technology, LLC. and its licensors retain all intellectual property
and proprietary rights in and to this software, related documentation
and any modifications thereto. Any use, reproduction, disclosure or
distribution of this software and related documentation without an express
license agreement from Open Vision Technology, LLC. is strictly prohibited.
'''

from control_operator_backend.mcp_server import create_json_topic
import asyncio
import logging
from contextlib import asynccontextmanager
from typing import Dict, List
import uuid

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request
from aiortc import RTCSessionDescription
from aiortc.sdp import candidate_from_sdp

try:
    from uli_py import Ocu
except ImportError:
    # Dummy class to prevent crash if not compiled locally
    logging.warning("uli_py not found. Mocking Ocu for testing.")
    class Ocu:
        def __init__(self, *args, **kwargs): pass
        def initialize(self): pass
        def instantiate(self): pass
        def set_up_actions(self): pass
        def start_up_actions(self): pass
        def shutdown(self): pass
        def destroy(self): pass
        async def get_data(self, url): return "{}"
        async def set_data(self, url, data): return

try:
    from uli_py import DataViewer
except ImportError:
    # Dummy class to prevent crash if not compiled locally
    logging.warning("uli_py not found. Mocking DataViewer for testing.")
    class DataViewer:
        def __init__(self, *args, **kwargs): pass
        def initialize(self): pass
        def instantiate(self): pass
        def set_up_actions(self): pass
        def start_up_actions(self): pass
        def shutdown(self): pass
        def destroy(self): pass
        async def get_data(self, url): return "{}"
        async def set_data(self, url, data): return
        def receive_topics(self): return []

from uli_py import UliTopicReader
from uli_py.json_topic import create_json_topic

from .config import load_config
from .webrtc_connection import WebRTCConnection
from .ocu_interface import OcuInterface
from .agent_handler import DeepAgentHandler

from mcp.server.sse import SseServerTransport
from .mcp_server import mcp_server

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger("backend_main")

connections: Dict[uuid.UUID, WebRTCConnection] = {}
ocu = None

async def topic_distribution_task(data_viewer: DataViewer):
    logger.info("[TopicDist] Starting global topic distribution task")
    try:
        while True:
            loop = asyncio.get_event_loop()
            topic_readers: List[UliTopicReader] = await loop.run_in_executor(None, data_viewer.receive_topics)
            
            if topic_readers:
                # put topics into the topic queue of each WebRTC connection
                for conn in connections.values():
                    for topic_reader in topic_readers:
                        try:
                            logger.debug(f"[{conn.id}] Topic {topic_reader.uri}")
                            # json_topic = create_json_topic(topic_reader)
                            # if json_topic:
                            #     conn.topic_queue.put_nowait(json_topic)
                        except Exception as e:
                            logger.error(f"[{conn.id}] Error processing topic: {e}")
            
            await asyncio.sleep(0)
    except asyncio.CancelledError:
        logger.info("[TopicDist] Topic distribution task cancelled")

async def agent_response_distribution_task():
    logger.info("[AgentDist] Starting global agent response distribution task")
    try:
        while True:
             # Placeholder: implement dynamic streaming logic back to client if needed
             await asyncio.sleep(0.5)
    except asyncio.CancelledError:
        logger.info("[AgentDist] Agent distribution task cancelled")


@asynccontextmanager
async def lifespan(app: FastAPI):
    global ocu
    config = load_config("./config.json")
    working_dir = config.get("working_dir", ".")
    
    logger.info(f"[Main] Config: {config}")
    logger.info(f"[Main] Working directory: {working_dir}")
    
    ocu = Ocu(working_dir)

    ocu.initialize()
    ocu.instantiate()
    ocu.set_up_actions()

    data_viewer = DataViewer(working_dir)

    data_viewer.initialize()
    data_viewer.instantiate()
    data_viewer.set_up_actions()

    # Initialize Interfaces Contexts
    ocu_intf = OcuInterface()
    ocu_intf.set_ocu(ocu)
    
    agent_handler = DeepAgentHandler()
    agent_handler.initialize()
    
    # Start tasks
    dist_task = asyncio.create_task(topic_distribution_task(data_viewer))
    agent_task = asyncio.create_task(agent_response_distribution_task())
    
    ocu.start_up_actions()
    data_viewer.start_up_actions()
    
    yield
    
    logger.info("[Main] Initiating graceful shutdown...")
    
    # Close all active WebRTC connections
    for conn in list(connections.values()):
        try:
            await conn.close()
        except Exception as e:
            logger.error(f"[Main] Error closing connection {conn.id}: {e}")
            
    try:
        data_viewer.shutdown()
        ocu.shutdown()
    except Exception as e:
        logger.error(f"[Main] Error in Ocu shutdown: {e}")
    
    dist_task.cancel()
    agent_task.cancel()
    
    try:
        await dist_task
        await agent_task
    except asyncio.CancelledError:
        pass
    
    agent_handler.shutdown()
    data_viewer.destroy()
    ocu.destroy()

app = FastAPI(lifespan=lifespan)

sse = SseServerTransport("/mcp/messages")

@app.get("/mcp/sse")
async def handle_sse(request: Request):
    async with sse.connect_sse(
        request.scope, request.receive, request._send
    ) as (read_stream, write_stream):
        await mcp_server.run(
            read_stream,
            write_stream,
            mcp_server.create_initialization_options(),
        )

@app.post("/mcp/messages")
async def handle_messages(request: Request):
    await sse.handle_post_message(
        request.scope, request.receive, request._send
    )


@app.websocket("/ws/rtc")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    
    conn = None
    try:
        while True:
            data = await websocket.receive_json()
            message_type = data.get("type")

            if message_type == "offer":
                conn = WebRTCConnection(websocket)
                connections[conn.id] = conn
                logger.info(f"[{conn.id}] Received offer, creating connection...")
                
                offer = RTCSessionDescription(sdp=data["sdp"], type=data["type"])
                await conn.connect(offer)
            
            elif message_type == "candidate" and conn:
                candidate_data = data.get("candidate")
                if candidate_data and candidate_data.get("candidate"):
                    candidate = candidate_from_sdp(candidate_data.get("candidate"))
                    candidate.sdpMid = candidate_data.get("sdpMid")
                    candidate.sdpMLineIndex = candidate_data.get("sdpMLineIndex")
                    await conn.pc.addIceCandidate(candidate)

    except WebSocketDisconnect:
        logger.info("Client disconnected.")
    finally:
        if conn:
            await conn.close()
            if conn.id in connections:
                del connections[conn.id]

def run_server():
    import uvicorn
    uvicorn.run("control_operator_backend.main:app", host="0.0.0.0", port=8080)

if __name__ == "__main__":
    run_server()
