# Backend Implementation Specifications

This document describes the backend implementation over the FastAPI framework. The backend provides WebRTC Server signaling, MCP server and data topics distribution.

## Overview

The backend is a FastAPI application. In its lifespan, it will read the configuration from `config.json`, start up the uli apps and the DeepAgent, and shut them down when the backend is shut down. The backend also implements the websocket endpoint, `/ws/rtc` for the WebRTC Server signaling.

The backend creates a async task to handle the data topics from uli apps and send them to the WebRTC Server. The backend creates a async task to handle the agent responses from DeepAgent and send them to the WebRTC Server.

## Core Stacks
- **framework:** Python, FastAPI.
- **Dependency management:** uv
- **WebRTC:** aiortc
- **uli SDK:** uli SDK
- **DeepAgent:** LangChain DeepAgent framework

## Implementation Notes

- The backend is implemented in the `backend` folder.
- The backend should be implemented modularly.
- The backend is implemented using FastAPI and aiortc.
- The backend is implemented using the uli apps classes: Ocu and DataViewer in the `reference_implementations/uli_py` folder.
- The backend is implemented using the LangChain DeepAgent framework.

## Coding Style

- The Python class name should be in PascalCase.
- The Python method name should be in snake_case.
- The Python variable name should be in snake_case.
- The Python constant name should be in UPPER_SNAKE_CASE.
- The Python file name should be in snake_case.
- The Python folder name should be in snake_case.
- The Python module name should be in snake_case.
- The Python package name should be in snake_case.

## Core Components

- **lifespan**
 1.  Reads configurations from `config.json`.
 2.  Instantiates, starts up and shuts down uli apps and the DeepAgent.
 3.  Create a background task to handle the data topics from uli apps and send them to the WebRTC Server.
 4.  Create a background task to handle the agent responses from DeepAgent and send them to the WebRTC Server.

- **uli app ocu**  
 1. Python classes that wrape the C++ interface of the ULI SDK application Ocu.
 2. The Ocu class implemented in the ocu.py file in the reference_implementations/uli_py folder.
   
- **uli app data viewer**  
 1. Python classes that wrape the C++ interface of the ULI SDK application DataViewer.
 2. The DataViewer class implemented in the data_viewer.py file in the reference_implementations/uli_py folder.
   
- **DeepAgent**  
 1. Uses LangChain DeepAgent framework.
 2. Receives user prompts, audio and image data from the main hub.
 3. Returns the text responses, audio and image data to the main hub.
 4. Call tools to set or get data from uli apps.

- **WebRTC Server**
 1. Handles WebRTC signaling and data exchange with the frontend.
  
- **Data Topic**
 1. it is to pack audio, video, 3-D objects(such as point cloud, mesh, etc.), and other multi-dimensional data (tensors, etc.).
 2. The main hub receives the data topics from uli apps over the receive_topics() method. The main hub forwards the received data topics to the frontend over the stream channel of the WebRTC.
 3. The main hub receives the data topics over the stream channel of the WebRTC from the frontend.
 4. The data topics received from the frontend are the images from the camera of the frontend and the audio from the microphone of the frontend. The main hub forwards the received audio and image data to the DeepAgent for inference.

- **WebRTC interface**
 1. Interface to the frontend.

### lifespan detailed

The `lifespan` is a FastAPI lifespan context manager. It is responsible for:
- Instantiating, starting up and shutting down uli apps and the DeepAgent.
- Creating background task, `ocu_topic_distribution_task`, for receiving topics from ULI SDK application Ocu and sending them to the WebRTC Server over the stream channel.
- Creating background task, `agent_response_distribution_task`, for receiving agent responses from DeepAgent and sending them to the WebRTC Server over the chat channel.

### uli app Ocu detailed

- It is a python class that wraps the C++ interface of the ULI SDK application Ocu.
- A global instance of uli app Ocu is created in the lifespan.
- It is started up and shut down by the lifespan.
- ocu.py in `reference_implementations/uli_py` folder is the python binding of uli app Ocu.
- The class methods are called during the startup sequence in this order:
    - initialize()
    - instantiate()
    - set_up_actions()
    - start_up_actions()
- The class methods are called during the shutdown sequence in this order:
    - shutdown()
    - destroy()

### Ocu Interface

Ocu Interface encapsulates the python binding get_data and set_data methods of the uli app Ocu. It is implemented as a singleton class and is used by the chat channel handler of the WebRTC Connection to get and set data to the uli app Ocu. They should also be tools called by the LangChain DeepAgent. Refer to the `docs/specs/ocu_intf.md` file for the detailed interface description.

Implemented methods:
- get_all_assets_abstractions() - retrieve the subsystem abstractions of all the discovered assets.
- get_asset_access_info() - retrieve the access client record of the selected subsystem.
- get_asset_control_info() - retrieve the control client record of the selected subsystem.
- get_asset_state_info() - retrieve the subsystem state client record of the selected subsystem.
- get_asset_operating_mode_info() - retrieve the operating mode client record of the selected subsystem.
- get_asset_status_details() - retrieve the status details of the selected subsystem.
- get_asset_available_agents() - retrieve the agent details of the selected subsystem.
- get_asset_agent_status() - retrieve the list of the status of all the agents of the selected subsystem.
- get_asset_agent_details() - retrieve the details of the agents of the selected subsystem.
- get_asset_data_topic_list() - retrieve the list of the data topics the selected subsystem is publishing.
- get_asset_data_topic_clients() - retrieve the list of the clients who subscribe the data topics of the selected subsystem.
- get_asset_transform_reporters() - retrieve the list of the transform reporters of the selected subsystem.
- get_asset_transform_reporters_clients() - retrieve the list of the clients who subscribe the transform reporters of the selected subsystem.
- set_gui_rec(gui_rec: str) - set the gui record.
- set_task_exec_rec(task_exec_rec: str) - set the task exec record.
- set_task_control_rec(task_control_rec: str) - set the task control record.

### MCP Server

MCP server is to have the tool calls available to the AI agents for the Ocu Interface.

### Ocu topic distribution

The background task, `ocu_topic_distribution_task`, for receiving topics from ULI SDK application Ocu and sending them to all the WebRTC Connections over the stream channel. Refer to the `ocu_topic_distribution_task` method in the `reference_implementations/ocu_webrtc/ocu_webrtc.py`.

The `ocu_topic_distribution_task` continuously polls for topics using the `receive_topics` method of the ULI SDK application Ocu. The `receive_topics` method returns a list of the PybindUliTopic objects. The `ocu_topic_distribution_task` enters the received topics into the topic queue of each connection.

The PybindUliTopic object can be converted to a JsonTopic object using the `create_json_topic()` method implemented in the `reference_implementations/uli_py/json_topic.py`. The StreamTopicWriter class can be used to convert the JsonTopic object to a bytes and write it to the stream_channel.

### Data Topic detailed

- It is to pack audio, video, 3-D objects(such as point cloud, mesh, etc.), and other multi-dimensional data (tensors, etc.).
- It is to be sent over the stream_channel of the WebRTC Server.
- The JsonTopic class is to be used to pack the data. It is implemented in `reference_implementations/uli_py/json_topic.py`.
- The StreamTopicReader class is to be used by the backend to read the bytes from the stream_channel and return the received JsonTopic object.
- The StreamTopicWriter class is to be used by the backend to convert the JsonTopic object to a bytes object and send it over the stream_channel.
- The receive_topics() method of the Ocu class is to be used by the backend to receive topics from the uli SDK. It returns a list of UliTopicReader objects.
- The create_json_topic() method is to be used by the backend to convert the UliTopicReader object to a JsonTopic object.
- The create_topic_builder_from_json_topic() method is to be used by the backend to convert the JsonTopic object to a UliTopicBuilder object.
- The publish_topic() method of the Ocu class is to be used by the backend to publish topics to the uli SDK. The methods of the UliTopicBuilder class are to be used to set the arguments of the publish_topic() method.

## DeepAgent detailed

Refer to the `docs/specs/deepAgent.md` for the DeepAgent specs.

## WebRTC Server detailed

Refer to the `docs/specs/webRTC_server.md` for the WebRTC server specs.

Each client connection has its own async tasks: `process_chat_queue` and `process_topic_queue` to process the received chat messages and json topics. This is to ensure that the processing of one client connection does not affect the processing of other client connections. Refer to the `reference_implementations/ocu_webrtc/ocu_webrtc.py` file for the implementation details.

### process_chat_queue detailed

The `process_chat_queue` is an async task that processes the received chat messages from the client connection. It calls the method of the OcuInterface class to get and set data to the uli app Ocu.

Refer to the `control_operator/specs/webRTC_intf.md` for the messaging protocol of the chat_channel of the WebRTC connection.

### process_topic_queue detailed

The `process_topic_queue` is an async task that processes the received PybindUliTopic objects for the client connection. It converts the PybindUliTopic objects to JsonTopic objects using the `create_json_topic()` method implemented in the `reference_implementations/uli_py/json_topic.py`. The StreamTopicWriter class in the same json_topic.py file is to be used by the backend to convert the JsonTopic object to a bytes object and send it over the stream_channel.
