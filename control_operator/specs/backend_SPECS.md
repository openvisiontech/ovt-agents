# Backend Implementation Specifications

This document describes the backend implementation over the FastAPI framework, refer to the implementation in the `reference_implementations/ocu_webrtc/ocu_webrtc.py` file.

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

1. The backend is implemented in the `backend` folder.
2. The backend should be implemented modularly.
3. The backend is implemented using FastAPI and aiortc.
4. The backend is implemented using the uli apps classes: Ocu and DataViewer in the `reference_implementations/uli_py` folder.
5. The backend is implemented using the LangChain DeepAgent framework.

## Coding Style

1. The Python class name should be in PascalCase.
2. The Python method name should be in snake_case.
3. The Python variable name should be in snake_case.
4. The Python constant name should be in UPPER_SNAKE_CASE.
5. The Python file name should be in snake_case.
6. The Python folder name should be in snake_case.
7. The Python module name should be in snake_case.
8. The Python package name should be in snake_case.

## Core Components

1. **lifespan**
   - Reads configurations from `config.json`.
   - Instantiates, starts up and shuts down uli apps and the DeepAgent.
   - Create a background task to handle the data topics from uli apps and send them to the WebRTC Server.
   - Create a background task to handle the agent responses from DeepAgent and send them to the WebRTC Server.

2. **uli app ocu**  
   - Python classes that wrape the C++ interface of the ULI SDK application Ocu.
   - The Ocu class implemented in the ocu.py file in the reference_implementations/uli_py folder.
   
3. **uli app data viewer**  
   - Python classes that wrape the C++ interface of the ULI SDK application DataViewer.
   - The DataViewer class implemented in the data_viewer.py file in the reference_implementations/uli_py folder.
   
4. **DeepAgent**  
   - Uses LangChain DeepAgent framework.
   - Receives user prompts, audio and image data from the main hub.
   - Returns the text responses, audio and image data to the main hub.
   - Call tools to set or get data from uli apps.

5. **WebRTC Server**
   - Handles WebRTC signaling and data exchange with the frontend.
  
6. **Data Topic**
   - it is to pack audio, video, 3-D objects(such as point cloud, mesh, etc.), and other multi-dimensional data (tensors, etc.).
   - The main hub receives the data topics from uli apps over the receive_topics() method. The main hub forwards the received data topics to the frontend over the stream channel of the WebRTC.
   - The main hub receives the data topics over the stream channel of the WebRTC from the frontend.
   - The data topics received from the frontend are the images from the camera of the frontend and the audio from the microphone of the frontend. The main hub forwards the received audio and image data to the DeepAgent for inference.

7. **WebRTC interface**
   - Interface to the frontend.

## lifespan detailed

The `lifespan` is a FastAPI lifespan context manager. It is responsible for:
1. Instantiating, starting up and shutting down uli apps and the DeepAgent.
2. Creating background task, `ocu_topic_distribution_task`, for receiving topics from ULI SDK application Ocu and sending them to the WebRTC Server over the stream channel.
3. Creating background task, `agent_response_distribution_task`, for receiving agent responses from DeepAgent and sending them to the WebRTC Server over the chat channel.

## uli app Ocu detailed

1. It is a python class that wraps the C++ interface of the ULI SDK application Ocu.
2. A global instance of uli app Ocu is created in the lifespan.
3. It is started up and shut down by the lifespan.
4. ocu.py in `reference_implementations/uli_py` folder is the python binding of uli app Ocu.
5. The class methods are called during the startup sequence in this order:
   - initialize()
   - instantiate()
   - set_up_actions()
   - start_up_actions()
6. The class methods are called during the shutdown sequence in this order:
   - shutdown()
   - destroy()

### Ocu Interface

Ocu Interface encapsulates the python binding get_data and set_data methods of the uli app Ocu. It is implemented as a singleton class and is used by the chat channel handler of the WebRTC Connection to get and set data to the uli app Ocu. They should also be tools called by the LangChain DeepAgent. Refer to the `specs/uli_app_ocu_intf_SPECS.md` file for the detailed interface description.

The following methods are implemented in the `OcuInterface` class:

1. get_all_subsystem_abstractions() - retrieve the subsystem abstractions of all the discovered assets.
2. get_asset_access_info() - retrieve the access client record of the selected subsystem.
3. get_asset_control_info() - retrieve the control client record of the selected subsystem.
4. get_asset_state_info() - retrieve the subsystem state client record of the selected subsystem.
5. get_asset_operating_mode_info() - retrieve the operating mode client record of the selected subsystem.
6. get_asset_status_details() - retrieve the status details of the selected subsystem.
7. get_asset_available_agents() - retrieve the agent details of the selected subsystem.
8. get_asset_agent_status() - retrieve the list of the status of all the agents of the selected subsystem.
9. get_asset_agent_details() - retrieve the details of the agents of the selected subsystem.
10. get_asset_data_topic_list() - retrieve the list of the data topics the selected subsystem is publishing.
11.  get_asset_data_topic_clients() - retrieve the list of the clients who subscribe the data topics of the selected subsystem.
12.  get_asset_transform_reporters() - retrieve the list of the transform reporters of the selected subsystem.
13.  get_asset_transform_reporters_clients() - retrieve the list of the clients who subscribe the transform reporters of the selected subsystem.
14.  set_gui_rec(gui_rec: str) - set the gui record.
15.  set_joystick(joystick1: str, joystick2: str) - set the joystick record.

### Ocu topic distribution

The background task, `ocu_topic_distribution_task`, for receiving topics from ULI SDK application Ocu and sending them to all the WebRTC Connections over the stream channel. Refer to the `ocu_topic_distribution_task` method in the `reference_implementations/ocu_webrtc/ocu_webrtc.py`.

The `ocu_topic_distribution_task` continuously polls for topics using the `receive_topics` method of the ULI SDK application Ocu. The `receive_topics` method returns a list of the PybindUliTopic objects. The `ocu_topic_distribution_task` enters the received topics into the topic queue of each connection.


 The PybindUliTopic object can be converted to a JsonTopic object using the `create_json_topic()` method implemented in the `reference_implementations/uli_py/json_topic.py`. The StreamTopicWriter class can be used to convert the JsonTopic object to a bytes and write it to the stream_channel.

### Data Topic detailed

1. It is to pack audio, video, 3-D objects(such as point cloud, mesh, etc.), and other multi-dimensional data (tensors, etc.).
2. It is to be sent over the stream_channel of the WebRTC Server.
3. The JsonTopic class is to be used to pack the data. It is implemented in `reference_implementations/uli_py/json_topic.py`.
4. The StreamTopicReader class is to be used by the backend to read the bytes from the stream_channel and return the received JsonTopic object.
5. The StreamTopicWriter class is to be used by the backend to convert the JsonTopic object to a bytes object and send it over the stream_channel.
6. The receive_topics() method of the Ocu class is to be used by the backend to receive topics from the uli SDK. It returns a list of UliTopicReader objects.
7. The create_json_topic() method is to be used by the backend to convert the UliTopicReader object to a JsonTopic object.
8. The create_topic_builder_from_json_topic() method is to be used by the backend to convert the JsonTopic object to a UliTopicBuilder object.
9. The publish_topic() method of the Ocu class is to be used by the backend to publish topics to the uli SDK. The methods of the UliTopicBuilder class are to be used to set the arguments of the publish_topic() method.

## DeepAgent detailed

## WebRTC Server detailed

Refer to the `specs/WebRTC_server_SPECS.md` for the WebRTC server specs.

Each client connection has its own async tasks: `process_chat_queue` and `process_topic_queue` to process the received chat messages and json topics. This is to ensure that the processing of one client connection does not affect the processing of other client connections. Refer to the `reference_implementations/ocu_webrtc/ocu_webrtc.py` file for the implementation details.

### process_chat_queue detailed

The `process_chat_queue` is an async task that processes the received chat messages from the client connection. It calls the method of the OcuInterface class to get and set data to the uli app Ocu.

Refer to the `control_operator/specs/WebRTC_intf_SPECS.md` for the messaging protocol of the chat_channel of the WebRTC connection.

### process_topic_queue detailed

The `process_topic_queue` is an async task that processes the received PybindUliTopic objects for the client connection. It converts the PybindUliTopic objects to JsonTopic objects using the `create_json_topic()` method implemented in the `reference_implementations/uli_py/json_topic.py`. The StreamTopicWriter class in the same json_topic.py file is to be used by the backend to convert the JsonTopic object to a bytes object and send it over the stream_channel.
