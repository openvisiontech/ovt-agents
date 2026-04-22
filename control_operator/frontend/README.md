# Control Operator Frontend

This is the strictly modular frontend application for the Control Operator system, built with Flutter and Riverpod. 

## 1. Implementation Outline

The application is structured into the following key modules:

- **`lib/main.dart` & `lib/main_layout.dart`**: The entrypoint and the core UI wrapper. `MainLayout` dynamically structures the header, global navigation buttons (Domain, Asset, AI Assist, Settings, EStop), and conditionally embeds the selected central screens.
- **`lib/models/*.dart`**: Contains the strongly typed Riverpod `Notifier` state models defining the structure of the specific data instances. Each core state is compartmentalized into files such as `gui_data_model.dart`, `header_data_model.dart`, `asset_data_model.dart`, `domain_data_model.dart`, `action_requests_data_model.dart`, `gamepad_data_model.dart`, and `stream_data_model.dart`.
- **`lib/providers/data_providers.dart`**: Instantiates and serves the globally accessible Riverpod `NotifierProvider` wrappers for the models.
- **`lib/comms/web_rtc_client.dart`**: A singleton WebRTC implementation establishing the communication link to the backend. It initializes twin data channels (`chat_channel` and `stream_channel`) and isolates the incoming/outgoing streams utilizing native event queues (`chatRequestQueue`, `streamRequestQueue`, `chatQueue`, `streamQueue`).
- **`lib/tasks/background_tasks_manager.dart` & `lib/tasks/*.dart`**: Handles continuous polling operations natively as asynchronous functions on the main execution loop (removing any Isolates to preserve complete Web compatibility). This encapsulates independent async routines such as `processChat`, `processActionRequests`, and `processGamepad`.
- **`lib/screens/`**: Houses the specific views injected into `MainLayout`. 
  - `asset_screen.dart`: Visualizes robotics or network asset telemetry and allows parameter assignments to individual agents.
  - `domain_screen.dart`: Displays the relational map traversing overarching subsystems.
  - `ai_assist_screen.dart`: Displays AI interactivity interfaces for payload scopes.

## 2. Configuration

The application is configured through a static JSON asset located at `assets/config.json`. 

- `workingDirectory` (String): Defines the local file system path or base directory structure to be strictly adhered to by natively injected FFI or logging frameworks in Desktop environments. Example: `"/var/tmp/control_operator"`.
- `webRtcUrl` (String): The signaling endpoint mapped securely via WebSockets connecting the Flutter frontend exclusively to the backend. Example: `"ws://127.0.0.1:8000/ws/rtc"`.
- `retryWebRTCConnect` (Integer): The timeout duration in milliseconds between continuous handshake attempts executed natively by the web application if the backend system disconnects dynamically. Example: `10000`.
- `logLevel` (String): Sets the verbosity of execution logs matching standard Dart logging levels (`"ALL"`, `"FINEST"`, `"FINER"`, `"FINE"`, `"CONFIG"`, `"INFO"`, `"WARNING"`, `"SEVERE"`, `"SHOUT"`, `"OFF"`). Example: `"FINE"`.

## 3. How to build and run

### 3.1 Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 
- Ensure you have run `flutter pub get` after cloning the project.

### 3.2 Running during Development
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

### 3.3 Build and Run Releases
To create optimized executable bundles for specific platforms, execute the build command. Once built, you can run the generated release bundles directly.

**For Linux Desktop:**
To build the Linux release bundle:
```bash
flutter build linux
```
The output executable will be located in the `build/linux/x64/release/bundle/` directory. You can run the application directly from this bundle:
```bash
./build/linux/x64/release/bundle/frontend
```

**For Web:**
To build the optimized web release bundle:
```bash
flutter build web
```
The compiled frontend application will be located in the `build/web/` directory. To serve it locally, you can use any static web server, such as Python's `http.server`:
```bash
cd build/web/
python3 -m http.server 8081
```

OR
```bash
./scripts/start_frontend.sh
```

Then, access the application in your browser at `http://localhost:8081`.

### 3.4 Packaging and Deployment

Once built, you can package the releases for distribution or deployment.

**Linux Desktop:**
To package the Linux build, create a compressed archive of the release bundle:
```bash
cd build/linux/x64/release/
tar -czvf control_operator_linux.tar.gz bundle/
```
You can then distribute the `control_operator_linux.tar.gz` archive. Simply extract it on the target Linux machine, navigate into the extracted `bundle/` directory, and run the `./frontend` executable.

**Web:**
To package the Web build, create a compressed archive of the web directory:
```bash
tar -czvf control_operator_web.tar.gz -C build/web/ .
```
For deployment, you can extract this archive or directly copy the contents of the `build/web/` directory to your web server's document root (e.g., Nginx, Apache, or a cloud-based static hosting service).
