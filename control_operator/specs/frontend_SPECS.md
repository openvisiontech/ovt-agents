# Frontend Implementation Specifications

This document is a specification for the frontend implementation of the Control Operator application.
The implementation is using Flutter and Riverpod. Refer to `reference_implementation/ocu_ui` for the reference implementation.

## 1. Overview and Architecture

The frontend is a cross-platform Flutter application tailored to run on Desktop (Linux), Web, and Mobile environments.

It creates a WebRTC connection to the backend with two data channels: char channel and stream channel. The WebRTC connection is used to send chat messages to the backend to request data or actions. It also sends the audio and image data, packed in the Json Topics, to the backend over the stream channel.

On the other hand, it also receives Json Topics from the backend over the stream channel. These Json Topics are the data topics from ULI SDK applications and the agent responses from DeepAgent. The frontend unpacks the Json Topics and displays the data in the frontend.

### 1.1 Core Stack
- **Framework:** Flutter
- **State Management:** Riverpod (`flutter_riverpod`)
- **Dependency Injection:** Conditional Platform Import Factory Pattern
- **Configuration:** Static JSON asset (`assets/config.json`)

### 1.2 Implementation Notes
- The frontend is implemented in the 'frontend' folder.
- The frontend should be modular and easy to maintain, refer to `reference_implementation/ocu_ui`.

### 1.3 Coding Styles
- The class names should be in PascalCase.
- The method names should be in snake_case.
- The variable names should be in snake_case.
- The constant names should be in UPPER_SNAKE_CASE.
- The file names should be in snake_case.
- The folder names should be in snake_case.

---

## 2. Configuration

### 2.1 Configurations (`assets/config.json`)
The configuration features are:
- `workingDirectory`: Base path consumed by the Linux FFI module.
- `webRtcUrl`: WebSocket signaling path consumed by WebRTC providers dynamically on Mobile/Web.

## 3. WebRTC

The frontend creates a WebRTC connection to the backend with two data channels: char channel and stream channel. The WebRTC connection is used to send chat messages to the backend to request data or actions. It also sends the audio and image data, packed in the Json Topics, to the backend over the stream channel.

On the other hand, it also receives Json Topics from the backend over the stream channel. These Json Topics are the data topics from ULI SDK applications and the agent responses from DeepAgent. The frontend unpacks the Json Topics and displays the data in the frontend.

The WebRTC client is responsible for sending messages to the backend and receiving messages from the backend. It is a singleton and should be accessed through the `WebRTCClient` class.

The WebRTC client is specified in the `specs/WebRTC_client_SPECS.md` file. Also Refer to `reference_implementation/ocu_ui/lib/providers/web_rtc_provider.dart` for the reference implementation.

The messaging protocol is specified in the `control_operator/specs/WebRTC_intf_SPECS.md` file.

The WebRTC client maintains the following async queues to send messages to the backend:

- chatRequestQueue: Queue of chat messages to be sent to the backend.
- streamRequestQueue: Queue of Json Topics to be sent to the backend.

- chatQueue: Queue of chat messages received from the backend.
- streamQueue: Queue of Json Topics received from the backend.

The WebRTC client should have async tasks to process the chatRequestQueue and streamRequestQueue. The async tasks send the messages to the backend over the chat channel and stream channel. The async tasks should be started when the WebRTC client is created. The async tasks should be stopped when the WebRTC client is disposed.

---

## 4. State Management & Dependency Injection

The frontend leverages Riverpod wrapping riverpod 3 notifier inheritance chains to broadcast structural state mutations efficiently to the UI layer components.

### 4.1 Data Models

Data for the GUI is organized into three main data models. Each data model is a `Notifier` that notifies its listeners of any changes.

#### 4.1.1**`GuiDataModel`**: Data related to the GUI.

  -userPresent: "UNKNOWN | PRESENT | NOT_PRESENT"

  It is set to PRESENT when either the left trigger or the right trigger is pulled. It is set to NOT_PRESENT when both the left trigger and the right trigger are released. It is set to UNKNOWN when there is no data from the GamepadDataModel.

  - navigatorBoxOnoff: boolean
  Toggled by the menu button in the Header

  - estop: boolean
  Toggled by the estop button in the Header

  - previousScreen: string
  - currentScreen: string
  Updated when the user navigates between screens

  - domainLeftSidebarVisible: boolean
  Toggled by the List button in the NavigatorBox

  - domainRightSidebarVisible: boolean
  To be determined

  - domainCommanderVisible: boolean
  Toggled by the Commander button

  - assetLeftSidebarVisible: boolean
  Toggled by the Agent button in the NavigatorBox

  - assetRightSidebarVisible: boolean
  To be determined

  - assetCommanderVisible: boolean
  Toggled by the Commander button in the NavigatorBox

#### 4.1.2**`HeaderDataModel`**: Data to be populated in the header of the GUI. 

  Data displayed in the header of the GUI:

  estop: "CLEAR | ESTOP"

#### 4.1.3**`DomainDataModel`**: holds the states needed for the domain screen with user interactions of the frontend.

  - subsystemControlAbstractions: 

  Updated by the chat message "all_control_abstractions" from the backend. It is a list of the control abstractions of all the discovered subsystems (assets). Refer to WebRTC_intf_SPECS.md for the payload structure.

  - asset list:
  
  Updated with each list item displaying the `Name`, `SubsystemType`, and `ControlStatus` of the subsystemControlAbstraction.
  The left sidebar of the domain screen is updated with the asset list. When traversing the asset list, the following fields are updated with the corresponding fields of the current subsystemControlAbstraction:

  currentAssetIndex: index of the current asset in the asset list
  currentAssetSubsystemId: subsystem id of the current asset
  currentAssetNodeId: node id of the current asset
  currentAssetCompId: comp id of the current asset
  currentAssetName: name of the current asset
  currentAssetControlStatus: control status of the current asset
  currentAssetControlAvail: control availability of the current asset

  When the "Check" button is pressed, the current asset is selected. The following actions are performed:
  
  1) The fields in the GuiDataModel related to selected asset are updated as below:
   
    subsystemId = subsystemControlAbstraction.subsystemId
    nodeId = subsystemControlAbstraction.nodeId
    compId = subsystemControlAbstraction.compId
    name = subsystemControlAbstraction.name
    controlStatus = "UNKNOWN"
    controlAvail = "UNKNOWN"
    haveAccess = "UNKNOWN"
    appAccessRight = "UNKNOWN"
    dataAccessRight = "UNKNOWN"
    haveControl = "UNKNOWN"
    subsystemState = "UNKNOWN"
    operatingCategory = "UNKNOWN"
    operatingMode = "UNKNOWN"

  2) The fields in the AssetDataModel related to selected asset are updated as below:
   
    subsystemId = subsystemControlAbstraction.subsystemId
    nodeId = subsystemControlAbstraction.nodeId
    compId = subsystemControlAbstraction.compId
    name = subsystemControlAbstraction.name
    interactionMode = "WATCH"
    estopButton = "CLEAR"
    subsystemStateCmd = "UNKNOWN"
    operatingCategory = "UNKNOWN"
    operatingMode = "UNKNOWN"
    agentName = ""
    agentUri = ""
    agentConfiguration = ""
    agentRunningCmd = "UNKNOWN"
    agentControlCmd = "UNKNOWN"
    userParams = ""
    agentCompletionTimeout = 0

#### 4.1.4 **`AssetDataModel`**: A data model that holds the states needed for the asset components interactions of the frontend. It is a `Notifier` that notifies its listeners of any changes.

  - assetAccessInfo:
  
    Updated by the chat message "asset_access_info" from the backend. It is the info of access client to the selected asset. Refer to WebRTC_intf_SPECS.md for the payload structure.

  - assetControlInfo:

    Updated by the chat message "asset_control_info" from the backend. It is the info of control client to the selected asset. Refer to WebRTC_intf_SPECS.md for the payload structure.

  - stateInfo:
  
    Updated by the chat message "state_info" from the backend. It is the info of state client to the selected asset. Refer to WebRTC_intf_SPECS.md for the payload structure.
  
  - operatingModeInfo:

    Updated by the chat message "operating_mode_info" from the backend. It is the info of operating mode client to the selected asset. Refer to WebRTC_intf_SPECS.md for the payload structure.
    
  - statusDetails:

    Updated by the chat message "status_details" from the backend. It is the status details of the selected asset. Refer to WebRTC_intf_SPECS.md for the payload structure.
      
  - agentList:

    Updated with each list item displaying the `Name` and `Uri` of the agent by the chat message "available_agents" from the backend. It is the list of agents of the selected asset. Refer to WebRTC_intf_SPECS.md for the payload structure. The agent list is displayed in the left sidebar of the asset screen.

  - fields updated by UI operations

    currentAgentIndex: -1
    currentAgentName: "UNKNOWN"
    currentAgentUri: ""

    userPresent: "UNKNOWN | PRESENT | NOT_PRESENT"
    subsystemId: "number"
    nodeId: "number"
    compId: "number"
    interactionMode: "UNKNOWN | NONE | WATCH | CONTROL"
    estopButton: "UNKNOWN | CLEAR | SET | UNCHANGE"
    subsystemStateCmd: "UNKNOWN | RESET | SHUTDOWN | RENDER_USELESS | OPERATIONAL"
    operatingCategory: "UNKNOWN | STANDARD | ADMINISTRATIVE"
    operatingMode: "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE"
    selectedAgentName: ""
    selectedAgentUri: ""
    agentRunningCmd: "UNKNOWN | IDLE | RUN | STOP | ABORT"
    agentControlCmd: "UNKNOWN | RESUME | PAUSE | CANCEL"
    userParams: "string"
    agentCompletionTimeout: number

    When traversing the agent list, the currentAgentIndex, currentAgentName and currentAgentUri are updated.
    When the agent is selected, the selectedAgentName and selectedAgentUri are updated, and the following fields are updated as below:

    agentRunningCmd = "UNKNOWN"
    agentControlCmd = "UNKNOWN"
    userParams = ""
    agentCompletionTimeout = 0
  
#### 4.1.5 **`ActionRequestsDataModel`**: A data model that allows the GUI to request actions from the backend. When the GUI wants to request an action from the backend, it sets the corresponding boolean to true. A background async task, `processActionRequests()` is to go through the action requests and put the corresponding chat message to the chat request queue of the WebRTC client and set the boolean to false after queueing the chat message. The async task is to be run in a separate isolate.

  - assetListUpdate
  - assetListAutoUpdate

  - serviceListUpdate
  - agentListUpdate
  - resourceListUpdate
  - dataTopicListUpdate
  - dataTopicClientListUpdate
  - transformReporterListUpdate

  - statusDetailsUpdate
  - resourceDetailsUpdate
  - agentStatusUpdate
  - agentDetailsUpdate
  - serviceListAutoUpdate

#### 4.1.6 **`GamepadDataModel`**: A data model that holds the states needed for the gamepad components interactions of the frontend. It is a `Notifier` that notifies its listeners of any changes.

  - gamepadDataReceived: boolean
  - leftJoystickX: number
  - leftJoystickY: number
  - rightJoystickX: number
  - rightJoystickY: number
  - leftTrigger: number
  - rightTrigger: number
  - leftGrip: number
  - rightGrip: number
  - buttonA: "UNKNOWN | PRESSED | RELEASED"
  - buttonB: "UNKNOWN | PRESSED | RELEASED"
  - buttonX: "UNKNOWN | PRESSED | RELEASED"
  - buttonY: "UNKNOWN | PRESSED | RELEASED"
  - buttonL1: "UNKNOWN | PRESSED | RELEASED"
  - buttonR1: "UNKNOWN | PRESSED | RELEASED"
  - buttonL2: "UNKNOWN | PRESSED | RELEASED"
  - buttonR2: "UNKNOWN | PRESSED | RELEASED"
  - buttonL3: "UNKNOWN | PRESSED | RELEASED"
  - buttonR3: "UNKNOWN | PRESSED | RELEASED"
  - buttonStart: "UNKNOWN | PRESSED | RELEASED"
  - buttonSelect: "UNKNOWN | PRESSED | RELEASED"
  - buttonHome: "UNKNOWN | PRESSED | RELEASED"  

#### 4.1.7 **`StreamDataModel`**: A data model that holds a list of received Json Topics to display. It is a `Notifier` that notifies its listeners of any changes.

  - Json Topics list
    
    The list is updated by the stream messages from the backend. The background async task `processStreamMessages()` is to go through the stream messages and put the corresponding json topics to the json topics list. The Json Topics are displayed in the center views of the domain screen and the asset screen.

    The background task `expireJsonTopics()` is to go through the json topics list and remove the expired json topics. The expiration time is specified in the data topic list from the backend.

---

## 5. Background Async Tasks

All the background async tasks are run as asynchronous functions onto the main execution loop

### 5.1 **`processActionRequests()`**

It periodically goes through the action requests and puts the corresponding chat message to the chat request queue of the WebRTC client and set the boolean to false after queueing the chat message. It is loop interval is 10ms. The `processActionRequests()` gets the requests from the ActionRequestsDataModel.

Perform the following actions every 50ms:

  1) if `assetListUpdate` is true, put to the chatRequestQueue the chat message for get_all_control_abstractions action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `assetListUpdate` to false.

  2) if `agentListUpdate` is true, put to the chatRequestQueue the chat message for get_available_agents action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `agentListUpdate` to false.

  3) if `dataTopicListUpdate` is true, put to the chatRequestQueue the chat message for get_data_topic_list action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `dataTopicListUpdate` to false.

  4) if `dataTopicClientListUpdate` is true, put to the chatRequestQueue the chat message for get_data_topic_clients action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `dataTopicClientListUpdate` to false.

  5) if `transformReporterListUpdate` is true, put to the chatRequestQueue the chat message for get_transform_reporters action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `transformReporterListUpdate` to false.

  6) if `statusDetailsUpdate` is true, put to the chatRequestQueue the chat message for get_status_details action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `statusDetailsUpdate` to false.

  7) if `agentStatusUpdate` is true, put to the chatRequestQueue the chat message for get_agent_status action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `agentStatusUpdate` to false.

  8) if `agentDetailsUpdate` is true, put to the chatRequestQueue the chat message for get_agent_details action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then set `agentDetailsUpdate` to false.


Perform the following actions every 100ms:

  1) if `assetListAutoUpdate` is true, put to the chatRequestQueue the chat message for get_all_control_abstractions action, refer to WebRTC_intf_SPECS.md for the chat message structure. Then keep the assetListAutoUpdate as true.

  2) put to the chatRequestQueue the chat message for get_asset_access_info action, refer to WebRTC_intf_SPECS.md for the chat message structure.

  3) Put to the chatRequestQueue the chat message for get_asset_control_info action, refer to WebRTC_intf_SPCS.md for the chat message structure.

  4) Put to the chatRequestQueue the chat message for get_state_info action, refer to WebRTC_intf_SPCS.md for the chat message structure.

  5) Put to the chatRequestQueue the chat message for get_operating_mode_info action, refer to WebRTC_intf_SPCS.md for the chat message structure.

### 5.2 **`processMediaRequests()`**

It periodically goes through the media requests and puts the corresponding Json Topics to the stream request queue of the WebRTC client and set the boolean to false after queueing the Json Topics. It is loop interval is 10ms.

### 5.3 **`processChat()`**

It waits for the chat messages from the Chat Queue of the WebRTC client and updates the corresponding data models. Refer to Section 2.1.2 `Backend to Frontend messages` in the WebRTC_intf_SPECS.md for the chat message structure.

1) Receive action `all_control_abstractions`

   - Update the subsystemControlAbstractions list in the `DomainDataModel` with the received "subsystemcontrolabstractions" list.

2) Receive action `asset_access_info`

   - Update the _assetAccessInfo in the `AssetDataModel` with the received "assetclient" object.

3) Receive action `asset_control_info`

   - Update the _assetControlInfo in the `AssetDataModel` with the received "controlclient" object.

4) Receive action `state_info`

   - Update the stateInfo in the `AssetDataModel` with the received "stateclient" object.

5) Receive action `operating_mode_info`

   - Update the operatingModeInfo in the `AssetDataModel` with the received "operatingmodeclient" object.

6) Receive action `status_details`

   - Update the statusDetails list in the `AssetDataModel` with the received "statusdetails" list.

7) Receive action `available_agents`

   - Update the _agentList in the `AssetDataModel` with the received "agentlist" list.

8) Receive action `agent_status`

   - Update the _agentStatus in the `AssetDataModel` with the received "agentstatuslist" list.
  
9) Receive action `agent_details`

   - Update the _agentDetails in the `AssetDataModel` with the received "agentdetails" object.

10) Receive action `data_topic_list`

   - Update the _dataTopicList in the `AssetDataModel` with the received "datatopiclist" list.

11) Receive action `data_topic_clients`

   - Update the _dataTopicClientList in the `AssetDataModel` with the received "datatopicclientlist" list.

12) Receive action `transform_reporters`

   - Update the _transformReporterList in the `AssetDataModel` with the received "transformreporterlist" list.

13) Receive action `transform_reporters_clients`

   - Update the _transformClientList in the `AssetDataModel` with the received "transformclientlist" list.

### 5.4 **`processStream()`**

It waits for the Json Topics from the Stream Queue of the WebRTC client and updates the `StreamDataModel`. When a Json Topic is entered into the `StreamDataModel`, its pub_time is updated to the current time and will be displayed. The `expireStreamData()` is to be run to remove the expired Json Topics from the `StreamDataModel`. It is loop interval is 10ms.

### 5.5 **`processGamepad()`**

It periodically polls the gamepad states and updates the `GamepadDataModel`. It is loop interval is 100ms.

### 5.6 **`expireStreamData()`**

It periodically checks the `StreamDataModel` and removes the expired Json Topics. It is loop interval is 100ms.

---

## 6. User Interface (UI) Components

The UI Main Layout and the subscreens are the same as the reference implementation exception that views are renamed screens. Refer to `specs\frontend_reference_SPECS.md` for the details.

### 6.1 Core Layout Component (`MainLayout`)

- Reactively spans infinite dimensions `double.infinity` dynamically matching the host Window Manager restrictions. (Note: Embedded GTK application settings have OS-level decorations globally enforced to permit universal dragging/resizing via `gtk_window_set_decorated(window, TRUE)`).

- **Responsive Navigation:** Reads `MediaQuery.of(context).size.width` identifying `Style.smallDeviceBreakpoint` limits. 
  1) Standard View: Buttons layout laterally along a single unified horizontal header array.
  2) Small Form Factor: Buttons snap to grid layouts seamlessly placing context titles vertically.

### 6.2 **`MainLayout`**

The main layout includes the header and the context box. It dynamically injects the sub-screens into the context box based on `guiData.currentScreen`.

The header includes the navigation buttons, estop button, and the menu button. The navigation buttons are used to navigate between the sub-screens. The menu button is used to toggle the visibility of the navigation box of the sub-screen.

The Header Center View is the area for the sub-screen to display its header information. For example, the asset screen displays information releated to the currently selected asset, including:

  address: subsystemId + "." + nodeId + "." + compId
  name: string
  
  if (haveAccess == "YES")
    appAccessRight: "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR"
    dataAccessRight: "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED"

  haveControl: use an icon to indicate the state. If haveControl == "NO", the icon is gray. If haveControl == "YES", the icon is green.
  subsystemState: "UNKNOWN | RESET | SHUTDOWN | RENDER_USELESS | OPERATIONAL"
  operatingMode: "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE"

### 6.3 Sub-Screens

#### 6.3.1 **`Common Sub-Screen Components`**

All the sub-screens have the same layout structure below. The difference is the content of the sub-screen.

  1) NavigatorBox - host a list of buttons to navigate functions of the sub-screen.
  
  2) CenterBox - host the main view of the sub-screen. It consists of three parts:
   
    - LeftSideBar: 1/4 of the CenterBox width if visible, else 0. It is populated with the list of items, for example, asset list in the domain screen, agent list in the asset screen.
    - MainContent: rest of the CenterBox width. It hosts a foating fractionally sized window for displaying detailed information of the selected item.
    - RightSideBar: 1/4 of the CenterBox width if visible, else 0.
   
    The LeftSideBar and RightSideBar are in the same row with the MainContent, and the MainContent is in the middle of the LeftSideBar and RightSideBar.

    In case of small screen, the LeftSideBar, MainContent, and RightSideBar are in full screen width and stacked on top of each other in the order of LeftSideBar, MainContent, and RightSideBar. A wheel button is displayed on the header to slide through the LeftSideBar, MainContent, and RightSideBar to toggle their visibility.

  3) Footer - host the drawer style of the commander buttons of the sub-screen.

#### 6.3.2 **`DomainScreen`**:
  Renders holistic overarching topological and relational maps cleanly. Same as the domain_view in the reference implementation.
  The `List` button toggles the visibility of the LeftSideBar.
  The `Graph` button toggles the visibility of the RightSideBar.
  The LeftSideBar is populated with the asset list.
  The MainContent is populated with the domain graph that is the 3D visualization of the domain.
  The RightSideBar is invisible by default.

#### 6.3.3 **`AssetScreen`**:
  Visualizes immediate robotics or network asset telemetries and metrics realistically. Same as the asset_view in the reference implementation.
  The `Agents` button toggles the visibility of the LeftSideBar.
  The LeftSideBar is populated with the agents list.
  The MainContent is populated with the asset graph that is the 3D visualization of the data topics published by the asset.
  The RightSideBar is invisible by default.

  The assetHeaderWidget is to be injected to the Header Center View when the Asset Screen is on display. It is to display the following information of the selected asset, which is updated through the AssetDataModel.

  address: subsystemId + "." + nodeId + "." + compId
  name: string
  
  if (haveAccess == "YES")
    appAccessRight: "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR"
    dataAccessRight: "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED"

  haveControl: use an icon to indicate the state. If haveControl == "NO", the icon is gray. If haveControl == "YES", the icon is green.

  subsystemState: "UNKNOWN | RESET | SHUTDOWN | RENDER_USELESS | OPERATIONAL"
  operatingMode: "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE"

#### 6.3.4 **`AIAssistScreen`**:
  Centralizes interactive conversational interfaces rendering LLM operations directly inside the payload scopes seamlessly. Same as the ai_assist_view in the reference implementation.

### 6.4 Styling Elements (`Style`)
To maintain consistency seamlessly, UI aesthetics (margins, exact breakpoints globally bounding elements, highlight hex parameters seamlessly) are statically constrained identically inside `lib/style.dart`.
