import argparse
import asyncio
import logging
from contextlib import asynccontextmanager
from typing import Dict
import uuid

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from aiortc import RTCSessionDescription

try:
    from pybinds.uli_py import Ocu
except ImportError:
    # Dummy class to prevent crash if not compiled locally
    logging.warning("pybinds.uli_py not found. Mocking Ocu for testing.")
    class Ocu:
        def __init__(self, *args, **kwargs): pass
        def initialize(self): pass
        def instantiate(self): pass
        def set_up_actions(self): pass
        def start_up_actions(self): pass
        def shutdown_actions(self): pass
        def destroy(self): pass
        async def get_data(self, url): return "{}"
        async def set_data(self, url, data): return
        def receive_topics(self): return []

from .config import load_config
from .webrtc_connection import WebRTCConnection
from .ocu_interface import OcuInterface
from .agent_handler import DeepAgentHandler

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("backend_main")

connections: Dict[uuid.UUID, WebRTCConnection] = {}
ocu = None

async def ocu_topic_distribution_task(ocu: Ocu):
    logger.info("[TopicDist] Starting global topic distribution task")
    try:
        while True:
            loop = asyncio.get_event_loop()
            topics = await loop.run_in_executor(None, ocu.receive_topics)
            
            if topics:
                for conn in connections.values():
                    conn.topic_queue.put_nowait(topics)
            
            await asyncio.sleep(0.1)
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
    config = load_config("control_operator/backend/config.json")
    working_dir = config.get("working_dir", ".")
    
    ocu = Ocu(working_dir)
    ocu.initialize()
    ocu.instantiate()
    ocu.set_up_actions()
    
    # Initialize Interfaces Contexts
    ocu_intf = OcuInterface()
    ocu_intf.set_ocu(ocu)
    
    agent_handler = DeepAgentHandler()
    agent_handler.initialize()
    
    # Start tasks
    dist_task = asyncio.create_task(ocu_topic_distribution_task(ocu))
    agent_task = asyncio.create_task(agent_response_distribution_task())
    
    ocu.start_up_actions()
    
    yield
    
    ocu.shutdown_actions()
    dist_task.cancel()
    agent_task.cancel()
    
    try:
        await dist_task
        await agent_task
    except asyncio.CancelledError:
        pass
    
    agent_handler.shutdown()
    ocu.destroy()

app = FastAPI(lifespan=lifespan)

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
                if candidate_data:
                    candidate = RTCSessionDescription(
                        candidate=candidate_data.get("candidate"),
                        sdpMid=candidate_data.get("sdpMid"),
                        sdpMLineIndex=candidate_data.get("sdpMLineIndex")
                    )
                    await conn.pc.addIceCandidate(candidate)

    except WebSocketDisconnect:
        logger.info("Client disconnected.")
    finally:
        if conn:
            await conn.close()
            if conn.id in connections:
                del connections[conn.id]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
