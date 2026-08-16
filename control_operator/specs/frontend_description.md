# Control Operator Frontend Description

## Overview
The Control Operator frontend is a heavily modularized Flutter application tailored for cross-platform deployment (Desktop & Web). Its primary purpose is to visualize the ULI SDK data, manipulate user-driven actions, handle bidirectional multi-channel WebRTC streaming, and elegantly isolate application state management leveraging Riverpod provider architectures.

## Directory Structure
- `lib/main.dart` & `lib/main_layout.dart`: The global configuration entrypoint and the top-level responsive scaffold orchestrating screen embedding.
- `lib/models/`: Holds independent state classes (e.g., `gui_data_model.dart`, `stream_data_model.dart`) decentralizing application memory.
- `lib/providers/data_providers.dart`: Instantiates and serves the globally accessible Riverpod `NotifierProvider` wrappers for the models.
- `lib/comms/web_rtc_client.dart`: A centralized Singleton governing WebSocket handshakes and RTC Datachannel connectivity completely independently from the UI stack.
- `lib/tasks/`: Contains precise background polling loops executed natively onto the flutter primary thread ensuring non-blocking operations and full web runtime support.
- `lib/screens/`: Maintains discrete presentation files for specific workflows: domains, assets, and AI assistance. Note: The central list of assets, previously housed in the Domain screen, has been migrated to the Asset Screen to consolidate asset-management workflows.
- `assets/config.json`: The core static configuration bundle utilized for injecting WebSockets and intervals variables dynamically.

## Main Layout

The main layout includes the header and the content box. It dynamically injects the sub-screens into the content box based on `guiData.currentScreen`.

The header includes the view buttons, estop button, and the menu button. The view buttons are used to navigate between the sub-screens. The menu button is used to toggle the visibility of the navigation box of the sub-screen.

The Header Center View is the area for the sub-screen to display its header information. For example, the asset screen displays information releated to the currently selected asset, including:

  address: subsystemId + "." + nodeId + "." + compId
  name: string
  
  if (haveAccess == "YES")
    appAccessRight: "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR"
    dataAccessRight: "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED"

  haveControl: use an icon to indicate the state. If haveControl == "NO", the icon is gray. If haveControl == "YES", the icon is green.
  subsystemState: "UNKNOWN | RESET | SHUTDOWN | RENDER_USELESS | OPERATIONAL"
  operatingMode: "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE"

## Sub-Screen Layout
The core sub-screens (Domain, Asset, and AI Assist) share a unified layout paradigm composed of nested, responsive elements that dynamically adapt to device constraints:
### **Navigator Box**: The contextual navigation bar handling primary routing or side-toggles.
### **Content Box**: The primary layout wrapper bounding the active view's interior content. It includes:
- **Center Box**: The main horizontal stretch occupying the bulk of the screen.
- **Left Side Bar**: A togglable side panel utilized for lists, directories, or contextual options. In the Asset Screen, this sidebar dynamically shifts between displaying the `Assets` list (migrated from the Domain View), `Agents`, and `Data` utilizing a unified layout component.
- **Main Content**: The central interactive focal point rendering 3D environments, primary chat interfaces, or domain data graphs.
- **Fractionally Sized Box (Info Popup)**: An overlaid dynamic container placed carefully within the main content area serving as an interactive popup data view, sized dynamically to a proportional fraction (e.g., 80%) of the parent box.
- **Fractionally Sized Box (Selection Popup)**: laid on top of the Info Popup. This fractional sized box has 50% in both width and height of the parent box.
- **Right Side Bar**: An additional conditional side panel offering extended configuration, insights, or history logs.
### **Footer Box (Commander)**: A specialized, sticky bottom container housing actionable operational controls, macros, or gamepad mechanisms.

### Reusable Components
- **SelectableList Component**
A highly modular, state-agnostic generic widget (`lib/components/selectable_list.dart`) utilized to standardize lists across sidebars. Features include:
- Complete decoupling from external models by relying on constructor-passed callbacks and parameters.
- `statusColors` support for rendering inline colored indicator pips (useful for asset control states).
- `trailingWidgets` support, allowing arbitrary widgets (like `IconButton` parameters or 36x36 dynamic `Image.network` structures) to sit on the trailing edge of list items.
- A suite of documented visual examples resides at `lib/components/selectable_list_examples.dart` and can be rapidly viewed completely isolated from the main app tree via the `lib/selectable_list_example_main.dart` entrypoint.

## Component Integrations

### The Presentation Shell (`main_layout.dart`)
Serves as the master scaffold container dynamically adapting to runtime screen breakpoints:
Evaluates screen-specific header content dynamically shifting view perspectives conditionally around smaller breakpoints minimizing visual clutter.

- **The Global Header**
The persistent top bar hosted within `MainLayout` provides instant access to crucial components:
- **View Buttons**: Main navigation triggers interchanging the central view stack between screens: "Domain", "Asset", "AI Assist", and "Settings".
- **WebRTC Connection Status**: A dynamic visual indicator mapping the connection state of the `WebRTCClient`, reflecting disconnected (red), connecting (orange), or actively connected (green).
- **Toggle Button**: Activates and collapses the structural Navigation boundaries (e.g. Left Side Bar).
- **Exit Button**: Cleanly breaks execution contexts enforcing graceful Desktop shutdown natively (ignored on Web).
- **EStop Button**: A brightly highlighted global Emergency Stop module instantly intercepting active actions or macros securely.

### Provider Ecosystem (`data_providers.dart` & `models/`)
Integrates the `Riverpod` framework (combining `ChangeNotifierProvider` and standard `NotifierProviders`) to seamlessly propagate deep state modifications across `ConsumerWidget` builders natively.
- Logically categorizes state metrics into exactly 7 domains: `ActionRequests`, `Asset`, `Domain`, `Gamepad`, `Gui`, `Header`, and `Stream` to avoid monolithic interface rebuilds.
- Securely bounds static setup configurations mapped manually out of `assets/config.json` passing them broadly via an `appConfigProvider`.

### Asynchrony and The WebRTC Client (`web_rtc_client.dart`)
Strictly partitioned away from the widget tree, the client embodies the physical stream bridge crossing over into the Python backend:
- **Resilient Re-connectivity**: Encapsulates an independent asynchronous `while(_isProcessing)` reconnection loop gracefully handling dropped `WebSocketChannel` events via the `retryWebRTCConnect` integer timeout buffer.
- **Multiplexed Processing**: Synchronizes twin Datachannels separating textual data operations (`chat_channel`) from lightning-fast binary allocations (`stream_channel`). 

### Background Execution Loops (`background_tasks_manager.dart`)
Defines the high-frequency polling infrastructure:
- Strategically stripped of raw `dart:isolate` dependencies to guarantee un-compromised Flutter Web builds while still exploiting parallel asynchronous Future mechanisms.
- Continuously executes individual sequences on tight 10ms - 100ms interval loops.
- Employs granular handlers like executing backend data transmissions (`process_action_requests.dart`), tracking gamepad input velocities (`process_gamepad.dart`), or actively decomposing obsolete stale stream nodes globally (`expire_stream_data.dart`).

## Execution Flow summary

The frontend leverages a discrete, multi-layered execution architecture ensuring highly fluid UI reactivity while concurrently negotiating real-time WebSocket traffic. This architecture runs completely asynchronously within Flutter's native event-loop.

### Startup & Initialization Sequence
- **Riverpod Injection**: `main.dart` configures the global `ProviderScope` allowing the widget tree instant, localized access to application state models.
- **Configuration Load**: Parses `assets/config.json`, pushing essential connection variables (URIs, default intervals) directly into the dependency graph.
- **Background Sequence Ignition**: Triggers `BackgroundTasksManager.startAll(container)`, permanently spinning up independent, non-blocking operational loops (e.g. `processActionRequests`).
- **Client Connection**: Executes `WebRTCClient.connect()`, which loops physical WebSocket handshakes and sustains Datachannel continuity internally.

### Background Task Loops Integration
To strictly ensure Flutter Web cross-platform compatibility, execution loops avoid heavy `dart:isolate` threading computations. Instead, they exploit continuous `while(true)` Future sequences at varied intervals:
- **`processActionRequests`**: Iterates on a pure 10ms loop, but groups logic into 50ms and 100ms staggered checkpoints. It listens to UI-triggered boolean flags mapped in `actionRequestsProvider` (such as `assetListUpdate`). Upon a flag being true, it instantly constructs and appends standard JSON payloads (like `{"action": "get_all_subsystem_abstractions"}`) natively into the `webrtcClient.chatRequestQueue` for transmission. 
- **`processChat`**: Rapidly polling every 10ms, it empties text-based packets arriving inside `webrtcClient.chatQueue`. It parses the exact JSON strings and maps the resulting data (e.g., parsing the `agent_status` block) deeply into the `assetDataProvider` state structures effortlessly bridging the internal network logic back up to the frontend UI layer safely.
- **`processGamepad` & `expireStreamData`**: Operating on relaxed 100ms delays, these sequences handle continuous hardware input tracking decoupled from frame paints, alongside sweeping algorithms meant to actively garbage-collect stale node parameters preventing memory ballooning.
- **`processStream` & `processMediaRequests`**: Specialized loops capturing pure binary ingestion blocks or media blob requests.

### Interface Reactivity & Rendering
- **Inbound Consumption**: The moment background tasks like `processChat` append values into model repositories (like updating `assetData.subsystemAbstractions`), `Riverpod` triggers cascaded hooks locally.
- **Interface Inflation**: The internal Flutter rendering engine registers those modifications natively across active `ConsumerWidgets`, bypassing monolithic refreshes and independently rebuilding only the dynamic elements (at up to 120Hz).
