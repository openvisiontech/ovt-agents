import asyncio
import json
import logging
import uuid
from typing import Optional

from aiortc import RTCPeerConnection, RTCSessionDescription
from fastapi import WebSocket
from starlette.websockets import WebSocketState

from .ocu_interface import OcuInterface
from .agent_handler import DeepAgentHandler

logger = logging.getLogger("webrtc_connection")

class WebRTCConnection:
    def __init__(self, websocket: WebSocket):
        self.ws = websocket
        self.pc = RTCPeerConnection()
        self.id = uuid.uuid4()
        
        self.chat_channel = None 
        self.stream_channel = None
        self.chat_queue = asyncio.Queue()
        self.stream_queue = asyncio.Queue()
        self.topic_queue = asyncio.Queue()
        
        self.chat_task: Optional[asyncio.Task] = None
        self.topic_task: Optional[asyncio.Task] = None
        
        self.ocu_interface = OcuInterface()
        self.agent_handler = DeepAgentHandler()

        self.pc.on("icecandidate", self.on_icecandidate)
        self.pc.on("connectionstatechange", self.on_connectionstatechange)

    async def connect(self, offer: RTCSessionDescription):
        @self.pc.on("datachannel")
        def on_datachannel(channel):
            if channel.label == "chat_channel":
                logger.info(f"[{self.id}] Chat channel '{channel.label}' created by client.")
                self.chat_channel = channel

                @channel.on("open")
                def on_open():
                    logger.info(f"[{self.id}] Chat channel is open.")

                @channel.on("message")
                def on_message(message):
                    self.chat_queue.put_nowait(message)
            
            elif channel.label == "stream_channel":
                logger.info(f"[{self.id}] Stream channel '{channel.label}' created by client.")
                self.stream_channel = channel
                
                @channel.on("open")
                def on_open():
                    logger.info(f"[{self.id}] Stream channel is open.")

                @channel.on("message")
                def on_message(message):
                    self.stream_queue.put_nowait(message)

        await self.pc.setRemoteDescription(offer)
        answer = await self.pc.createAnswer()
        await self.pc.setLocalDescription(answer)
        
        await self.send({
            "type": "answer",
            "sdp": self.pc.localDescription.sdp,
        })
        
        self.chat_task = asyncio.create_task(self.process_chat_queue())
        self.stream_task = asyncio.create_task(self.process_stream_queue())
        self.topic_task = asyncio.create_task(self.process_topic_queue())

    async def on_icecandidate(self, candidate):
        if candidate:
            await self.send({
                "type": "candidate",
                "candidate": {
                    "candidate": candidate.candidate,
                    "sdpMid": candidate.sdpMid,
                    "sdpMLineIndex": candidate.sdpMLineIndex,
                },
            })

    def on_connectionstatechange(self):
        logger.info(f"[{self.id}] Connection state is {self.pc.connectionState}")
        if self.pc.connectionState in ["failed", "closed"]:
            asyncio.ensure_future(self.close())

    async def send(self, message: dict):
        if self.ws.client_state == WebSocketState.CONNECTED:
            await self.ws.send_json(message)

    async def send_chat(self, action: str, payload: dict):
        if self.chat_channel and self.chat_channel.readyState == "open":
            msg = json.dumps({"action": action, "payload": payload})
            self.chat_channel.send(msg)

    async def send_stream(self, message: bytes):
        if self.stream_channel and self.stream_channel.readyState == "open":
            self.stream_channel.send(message)

    async def close(self):
        if self.chat_task:
            self.chat_task.cancel()
        if self.topic_task:
            self.topic_task.cancel()
        if self.pc.connectionState != "closed":
            await self.pc.close()
        logger.info(f"[{self.id}] Peer connection closed.")

    async def process_chat_queue(self):
        logger.info(f"[{self.id}] Starting chat queue task")
        try:
            while True:
                message = await self.chat_queue.get()
                try:
                    data = json.loads(message)
                    action = data.get("action")
                    payload = data.get("payload", {})

                    # Route based on action
                    if action == "get_all_control_abstractions":
                        res = await self.ocu_interface.get_all_control_abstractions()
                        await self.send_chat("all_control_abstractions", json.loads(res))
                        logger.info(f"[{self.id}] send all_control_abstractions {res}")
                    elif action == "get_asset_access_info":
                        res = await self.ocu_interface.get_asset_access_info()
                        await self.send_chat("asset_access_info", json.loads(res))
                        logger.debug(f"[{self.id}] send asset_access_info {res}")
                    elif action == "get_asset_control_info":
                        res = await self.ocu_interface.get_asset_control_info()
                        await self.send_chat("asset_control_info", json.loads(res))
                        logger.debug(f"[{self.id}] send asset_control_info {res}")
                    elif action == "get_state_info":
                        res = await self.ocu_interface.get_state_info()
                        await self.send_chat("state_info", json.loads(res))
                        logger.debug(f"[{self.id}] send state_info {res}")
                    elif action == "get_operating_mode_info":
                        res = await self.ocu_interface.get_operating_mode_info()
                        await self.send_chat("operating_mode_info", json.loads(res))
                        logger.debug(f"[{self.id}] send operating_mode_info {res}")
                    elif action == "get_status_details":
                        res = await self.ocu_interface.get_status_details()
                        await self.send_chat("status_details", json.loads(res))
                        logger.debug(f"[{self.id}] send status_details {res}")
                    elif action == "get_available_agents":
                        res = await self.ocu_interface.get_available_agents()
                        await self.send_chat("available_agents", json.loads(res))
                        logger.debug(f"[{self.id}] send available_agents {res}")
                    elif action == "get_agent_status":
                        res = await self.ocu_interface.get_agent_status()
                        await self.send_chat("agent_status", json.loads(res))
                        logger.debug(f"[{self.id}] send agent_status {res}")
                    elif action == "get_agent_details":
                        res = await self.ocu_interface.get_agent_details()
                        await self.send_chat("agent_details", json.loads(res))
                        logger.debug(f"[{self.id}] send agent_details {res}")
                    elif action == "get_data_topic_list":
                        res = await self.ocu_interface.get_data_topic_list()
                        await self.send_chat("data_topic_list", json.loads(res))
                        logger.debug(f"[{self.id}] send data_topic_list {res}")
                    elif action == "get_data_topic_clients":
                        res = await self.ocu_interface.get_data_topic_clients()
                        await self.send_chat("data_topic_clients", json.loads(res))
                        logger.debug(f"[{self.id}] send data_topic_clients {res}")
                    elif action == "get_transform_reporters":
                        res = await self.ocu_interface.get_transform_reporters()
                        await self.send_chat("transform_reporters", json.loads(res))
                        logger.debug(f"[{self.id}] send transform_reporters {res}")
                    elif action == "get_transform_reporters_clients":
                        res = await self.ocu_interface.get_transform_reporters_clients()
                        await self.send_chat("transform_reporters_clients", json.loads(res))
                        logger.debug(f"[{self.id}] send transform_reporters_clients {res}")
                    elif action == "set_gui_rec":
                        guirec = payload.get("guirec")
                        if guirec:
                            await self.ocu_interface.set_gui_rec(guirec)
                            logger.debug(f"[{self.id}] set_gui_rec {guirec}")
                    elif action == "set_joystick":
                        joy1 = payload.get("joystick1rec")
                        joy2 = payload.get("joystick2rec")
                        await self.ocu_interface.set_joystick(joy1, joy2)
                        logger.debug(f"[{self.id}] set_joystick {joy1} {joy2}")
                    elif action == "user_prompt":
                        agent_name = payload.get("agent_name", "unknown")
                        prompt = payload.get("prompt", "")
                        response = await self.agent_handler.process_prompt(agent_name, prompt)
                        await self.send_chat("agent_response", {"agent_name": agent_name, "response": response})
                        logger.debug(f"[{self.id}] user_prompt {agent_name} {prompt}")
                    else:
                        logger.warning(f"Unknown action received: {action}")

                except json.JSONDecodeError as e:
                    logger.error(f"Failed to decode JSON chat message: {e}")
                except Exception as e:
                    logger.error(f"Error processing chat message: {e}")
                finally:
                    self.chat_queue.task_done()
        except asyncio.CancelledError:
            logger.info(f"[{self.id}] Chat task cancelled")

    async def process_stream_queue(self):
        logger.info(f"[{self.id}] Starting stream queue task")
        try:
            while True:
                message = await self.stream_queue.get()
                # To be implemented: Stream forwarding
                self.stream_queue.task_done()
        except asyncio.CancelledError:
            logger.info(f"[{self.id}] Stream task cancelled")

    async def process_topic_queue(self):
        logger.info(f"[{self.id}] Starting topic queue task")
        try:
            while True:
                message = await self.topic_queue.get()
                # To be implemented: Topic forwarding
                self.topic_queue.task_done()
        except asyncio.CancelledError:
            logger.info(f"[{self.id}] Topic task cancelled")
