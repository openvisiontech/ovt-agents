# WebRTC Client Specification

This document provides the specification for the WebRTC client implemented in `WebRtcProvider` (`reference_implementations/ocu_ui/lib/providers/web_rtc_provider.dart`).

## Overview
The WebRTC client extends `GuiDataProvider` and uses `flutter_webrtc` to manage real-time peer-to-peer connections. It handles connection signaling through WebSockets, establishes an audio/video stream (receive-only video), and multiplexes control data and streaming data over two distinct RTC data channels.

## Signaling
- **Transport**: WebSockets (`WebSocketChannel`).
- **Flow**: The client connects to the signaling server and listens for events.
- **Messages**: Exchanged as JSON strings with a `type` field.
  - `offer`: Sets the remote description and responds by creating and sending an `answer`.
  - `answer`: Sets the remote description with the received SDP.
  - `candidate`: Adds a received ICE candidate to the peer connection.
- **Initialization**: Upon creating a peer connection, the client creates an offer and sends it via the signaling channel. ICE candidates discovered locally are also sent directly to the signaling server.

## Peer Connection
- **ICE Servers**: Uses a public Google STUN server (`stun:stun.l.google.com:19302`).
- **SDP Semantics**: Configured to use `unified-plan`.

## Video Renderers
- Maintains two `RTCVideoRenderer` instances (`remoteRenderer1` and `remoteRenderer2`).
- **Transceivers**: Adds two video transceivers configured as `RecvOnly` (receive-only).
- **Track Handling**: When a remote video track is received, it assigns the incoming media stream to the first available initialized `RTCVideoRenderer`.

## RTC Data Channels
The client creates two active, ordered data channels:

### 1. `chat` Channel
- **Purpose**: Exchanging text-based action commands and control messages.
- **Characteristics**: Ordered channel.
- **Initialization**: Sends a greeting message (`"Flutter client says hello!"`) when the channel opens.
- **Receiving**: Text messages are passed to `handleAction(message.text)`. Logs a warning if binary data is incorrectly received.
- **Sending**: Uses the `sendAction(action, payload)` method to send JSON-encoded strings containing `action` and `payload`.

### 2. `stream` Channel
- **Purpose**: Receiving high-throughput binary data updates.
- **Characteristics**: Ordered channel.
- **Receiving**: Listens specifically for binary data. 
- **Parsing**: Uses `StreamTopicReader` (from `uli_ffi/uli.dart`) to unpack byte arrays into topic objects. It extracts GUI state updates from `topic.headJson` and iterates over `topic.dataJsons`, passing each distinct data JSON to `updateState(json)`. This channel is used primarily for receiving rapid data streaming updates.

## Lifecycle Management
- **Initialization**: The `connect()` method initializes the renderers, opens the signaling WebSocket, and creates the internal WebRTC PeerConnection flow.
- **Disposal**: The `dispose()` method gracefully closes the `chat` and `stream` data channels, shuts down the peer connection, closes the WebSocket signaling channel, and completely disposes of the active video renderers.
