# WebRTC server specs

This document describes the WebRTC server implementation in the backend. It is implemented over the WebRTC, refer to the WebRTCConnection class in `reference_implementations/ocu_webrtc/ocu_webrtc.py`.

## overview

The webRTC is a FastAPI and aiortc-based server. It facilitates bi-directional data exchange, system control, and media streaming over WebRTC connections. The backend implements the WebRTC server while the frontend implements the WebRTC client. The WebRTCConnection class is the main class that handles the WebRTC connection.

## Core Components

1. **Signaling Server (FastAPI / WebSockets)**  
   - Handles standard WebRTC SDP offer/answer exchange and ICE candidates.
   - Endpoint: `/rtc`

2. **WebRTC Peer Connection**  
   - Driven by `aiortc` components (`RTCPeerConnection`).
   - Supports multiplexed channels: chat channel, stream channel, and media tracks.

3. **Chat Handler**  
   - The recieved chat messages are entered into the chat_queue.
   - The `process_chat_task` is to process the messages in the chat_queue.  

4. **Stream Handler**
   - The received json topic messages are entered into the topic_queue.
   - The `process_topic_task` is to process the messages in the topic_queue.

5. **Media Handler**  
   - The received media messages are entered into the media_queue.
   - The `process_media_task` is to process the messages in the media_queue.

## Communication Channels Interface

### 1. WebRTC Signaling (WebSocket)
- **URL Endpoint**: `ws://<host>:<port>/rtc`
- **Messages Structure**:
  - `offer`: Initial SDP offer sent by the client. The server parses it and replies with an `answer` containing its local SDP.
  - `candidate`: ICE candidate exchanged for NAT traversal logic.
  
### 2. Chat Channel (`chat_channel`)
A reliable data channel used to exchange chat messages.
- **Channel Label**: `chat_channel`
- **Message Protocol (Client -> Server)**:
  - **get_data Request**: 
    ```json
    {
      "action": "<get_action>",
      "payload": {
      }
    }
    ```
  - **set_data Request**:
    ```json
    {
      "action": "<set_action>",
      "payload": {
        "data": "<json_payload_string>"
      }
    }
    ```
  - ***user prompt***
    ```json
    {
      "action": "user_prompt",
      "payload": {
        "agent_name": "<agent_name>",
        "prompt": "<prompt>"
      }
    }
    ```
- **Message Protocol (Server -> Client)**:
  - ***data response*** 
    For `get_data` requests, the server dynamically returns a JSON response containing the data of
  ```json
    {
      "action": "<data_response>",
      "payload": {
        "data": "<json_data_string>"
      }
    }
  ```
  - ***agent response***
    For `user_prompt` requests, the server dynamically returns a JSON response containing the response of the agent.
    ```json
    {
      "action": "agent_response",
      "payload": {
        "agent_name": "<agent_name>",
        "response": "<response>"
      }
    }
    ```

### 3. Stream Channel (`stream_channel`)
A bidirectional channel reserved for high-throughput, low-latency data topic streams.
- **Channel Label**: `stream_channel`
- **Steams**: of the JsonTopic, implemented in json_topic.py in the `reference_implementations/uli_py` folder.
  - The JsonTopic can be used to pack image, audio, video, 3-D objects(such as point cloud, mesh, etc.), and other multi-dimensional data (tensors, etc.).  
  - The StreamTopicReader class is to be used by the backend to read the bytes from the stream_channel and return the received data as a json object.
  - The StreamTipicWriter class is to be used by the backend to convert the JsonTopic to the bytes and send them over the stream_channel.
  - The JsonTopic includes uri and schema, which are used to identify the data topic and the data format.

### 4. Media Streaming Tracks (RTSP Video over WebRTC)
- Configured via `MediaPlayer` (from `aiortc.contrib.media`).
- Can handle ingesting standard RTSP video streams (e.g., camera feeds on robot or environment) and attaches them as outgoing video tracks in the WebRTC `RTCPeerConnection`.
- Allows clients to view feeds natively simply by setting a `<video>` element's `srcObject` to the peer connection's stream on the frontend.

