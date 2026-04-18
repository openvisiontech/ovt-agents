# Control Operator Frontend Description

## Overview
The Control Operator frontend is a heavily modularized Flutter application tailored for cross-platform deployment (Desktop & Web). Its primary purpose is to visualize the ULI SDK data, manipulate user-driven actions, handle bidirectional multi-channel WebRTC streaming, and elegantly isolate application state management leveraging Riverpod provider architectures.

## Directory Structure
- `lib/main.dart` & `lib/main_layout.dart`: The global configuration entrypoint and the top-level responsive scaffold orchestrating screen embedding.
- `lib/models/`: Holds independent state classes (e.g., `gui_data_model.dart`, `stream_data_model.dart`) decentralizing application memory.
- `lib/providers/web_rtc_client.dart`: A centralized Singleton governing WebSocket handshakes and RTC Datachannel connectivity completely independently from the UI stack.
- `lib/tasks/`: Contains precise background polling loops executed natively onto the flutter primary thread ensuring non-blocking operations and full web runtime support.
- `lib/screens/`: Maintains discrete presentation files for specific workflows: domains, assets, and AI assistance.
- `assets/config.json`: The core static configuration bundle utilized for injecting WebSockets and intervals variables dynamically.

## Component Integrations

### 1. The Presentation Shell (`main_layout.dart`)
Serves as the master scaffold container dynamically adapting to runtime screen breakpoints:
- Manages global Header controls (including Estop buttons) and sets global View routing statically natively.
- Evaluates screen-specific header content dynamically shifting view perspectives conditionally around smaller breakpoints minimizing visual clutter.

### 2. Provider Ecosystem (`data_providers.dart` & `models/`)
Integrates the `Riverpod` framework (combining `ChangeNotifierProvider` and standard `NotifierProviders`) to seamlessly propagate deep state modifications across `ConsumerWidget` builders natively.
- Logically categorizes state metrics into exactly 7 domains: `ActionRequests`, `Asset`, `Domain`, `Gamepad`, `Gui`, `Header`, and `Stream` to avoid monolithic interface rebuilds.
- Securely bounds static setup configurations mapped manually out of `assets/config.json` passing them broadly via an `appConfigProvider`.

### 3. Asynchrony and The WebRTC Client (`web_rtc_client.dart`)
Strictly partitioned away from the widget tree, the client embodies the physical stream bridge crossing over into the Python backend:
- **Resilient Re-connectivity**: Encapsulates an independent asynchronous `while(_isProcessing)` reconnection loop gracefully handling dropped `WebSocketChannel` events via the `retryWebRTCConnect` integer timeout buffer.
- **Multiplexed Processing**: Synchronizes twin Datachannels separating textual data operations (`chat_channel`) from lightning-fast binary allocations (`stream_channel`). 

### 4. Background Execution Loops (`background_tasks_manager.dart`)
Defines the high-frequency polling infrastructure:
- Strategically stripped of raw `dart:isolate` dependencies to guarantee un-compromised Flutter Web builds while still exploiting parallel asynchronous Future mechanisms.
- Continuously executes individual sequences on tight 10ms - 100ms interval loops.
- Employs granular handlers like executing backend data transmissions (`process_action_requests.dart`), tracking gamepad input velocities (`process_gamepad.dart`), or actively decomposing obsolete stale stream nodes globally (`expire_stream_data.dart`).

## Execution Flow summary
1. Startup Sequence: `main.dart` configures Riverpod Provider scopes > Evaluates the `config.json` representations > Ignites the `BackgroundTasksManager.startAll()` async sequences > And triggers `WebRTCClient.connect()` handshakes natively running iteratively until resolved.
2. Interface Inflation: `MainLayout` mounts subscribing to local DataProvider hooks dynamically traversing widgets inside `ref.watch`.
3. Inbound Consumption: As WebRTC connections formalize, asynchronous message parsing natively pushes the stream variables recursively down into the target data models.
4. Interface Reactivity: The internal flutter rendering engine (`CanvasKit`/Desktop) immediately registers and cascades component modifications dynamically outputting updates onto the user's graphical interface organically reacting up to 120Hz refresh rates.
