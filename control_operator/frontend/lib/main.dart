import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'providers/data_providers.dart';
import 'models/app_config.dart';
import 'package:logging/logging.dart';
import 'platform_utils.dart';
import 'dart:ui';

import 'main_layout.dart';
import 'comms/web_rtc_client.dart';
import 'tasks/background_tasks_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load config
  final configString = await rootBundle.loadString('assets/config.json');
  final configJson = jsonDecode(configString);
  final appConfig = AppConfig.fromJson(configJson);

  IOSink? logSink;
  if (!kIsWeb) {
    final logFile = File('${appConfig.workingDirectory}/control_operator.log');
    logSink = logFile.openWrite(mode: FileMode.append);
  }

  // Set up logging
  Logger.root.onRecord.listen((record) {
    final logLine = '${record.level.name}: ${record.time}: ${record.message}';
    print(logLine);
    logSink?.writeln(logLine);
  });

  final log = Logger('ocu_ui');

  Level parsedLevel;
  switch (appConfig.logLevel.toUpperCase()) {
    case 'ALL':
      parsedLevel = Level.ALL;
      break;
    case 'FINEST':
      parsedLevel = Level.FINEST;
      break;
    case 'FINER':
      parsedLevel = Level.FINER;
      break;
    case 'FINE':
      parsedLevel = Level.FINE;
      break;
    case 'CONFIG':
      parsedLevel = Level.CONFIG;
      break;
    case 'INFO':
      parsedLevel = Level.INFO;
      break;
    case 'WARNING':
      parsedLevel = Level.WARNING;
      break;
    case 'SEVERE':
      parsedLevel = Level.SEVERE;
      break;
    case 'SHOUT':
      parsedLevel = Level.SHOUT;
      break;
    case 'OFF':
      parsedLevel = Level.OFF;
      break;
    default:
      parsedLevel = Level.INFO;
  }
  Logger.root.level = parsedLevel;

  log.info('Current working directory: ${PlatformUtils.currentDirectory}');
  log.info(
    'Loaded config: workingDir=${appConfig.workingDirectory}, webRtcUrl=${appConfig.webRtcUrl}',
  );

  WebRTCClient().connect(appConfig.webRtcUrl, appConfig.retryWebRTCConnect);

  final container = ProviderContainer(
    overrides: [appConfigProvider.overrideWithValue(appConfig)],
  );
  BackgroundTasksManager.startAll(container);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onExitRequested: _onExitRequested);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  Future<AppExitResponse> _onExitRequested() async {
    try {
      WebRTCClient().dispose();
      BackgroundTasksManager.stopAll();
    } catch (e) {
      // ignore errors if provider is already disposed or not found
    }
    return AppExitResponse.exit;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCU Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainLayout(),
    );
  }
}
