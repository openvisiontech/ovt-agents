# Control Operator Frontend

This is the strictly modular frontend application for the Control Operator system, built with Flutter and Riverpod. 

## Implementation Outline

The application is structured into the following key modules:

- **`lib/main.dart` & `lib/main_layout.dart`**: The entrypoint and the core UI wrapper. `MainLayout` dynamically structures the header, global navigation buttons (Domain, Asset, AI Assist, Settings, EStop), and conditionally embeds the selected central screens.
- **`lib/models/*.dart`**: Contains the strongly typed Riverpod `Notifier` state models defining the structure of the specific data instances. Each core state is compartmentalized into files such as `gui_data_model.dart`, `header_data_model.dart`, `asset_data_model.dart`, `domain_data_model.dart`, `action_requests_data_model.dart`, `gamepad_data_model.dart`, and `stream_data_model.dart`.
- **`lib/providers/data_providers.dart`**: Instantiates and serves the globally accessible Riverpod `NotifierProvider` wrappers for the models.
- **`lib/providers/web_rtc_client.dart`**: A singleton WebRTC implementation establishing the communication link to the backend. It initializes twin data channels (`chat_channel` and `stream_channel`) and isolates the incoming/outgoing streams utilizing native event queues (`chatRequestQueue`, `streamRequestQueue`, `chatQueue`, `streamQueue`).
- **`lib/tasks/background_tasks_manager.dart` & `lib/tasks/*.dart`**: Handles continuous polling operations natively as asynchronous functions on the main execution loop (removing any Isolates to preserve complete Web compatibility). This encapsulates independent async routines such as `processChat`, `processActionRequests`, and `processGamepad`.
- **`lib/screens/`**: Houses the specific views injected into `MainLayout`. 
  - `asset_screen.dart`: Visualizes robotics or network asset telemetry and allows parameter assignments to individual agents.
  - `domain_screen.dart`: Displays the relational map traversing overarching subsystems.
  - `ai_assist_screen.dart`: Displays AI interactivity interfaces for payload scopes.

## Configuration

The application is configured through a static JSON asset located at `assets/config.json`. 

- `workingDirectory` (String): Defines the local file system path or base directory structure to be strictly adhered to by natively injected FFI or logging frameworks in Desktop environments. Example: `"/var/tmp/control_operator"`.
- `webRtcUrl` (String): The signaling endpoint mapped securely via WebSockets connecting the Flutter frontend exclusively to the backend. Example: `"ws://127.0.0.1:8000/ws/rtc"`.
- `retryWebRTCConnect` (Integer): The timeout duration in milliseconds between continuous handshake attempts executed natively by the web application if the backend system disconnects dynamically. Example: `10000`.

## How to build and run

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 
- Ensure you have run `flutter pub get` after cloning the project.

### Running during Development
You can run the frontend on a supported connected platform (such as Linux or Chrome):

**Linux:**
```bash
cd control_operator/frontend
flutter run -d linux
```

**Web (Chrome):**
```bash
cd control_operator/frontend
flutter run -d chrome
```

### Build Releases
To create optimized executable bundles for specific platforms, execute the build command:

**For Linux Desktop:**
```bash
flutter build linux
```

**For Web:**
```bash
flutter build web
```
