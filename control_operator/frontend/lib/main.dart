import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'providers/data_providers.dart';
import 'models/app_config.dart';
import 'package:logging/logging.dart';
import 'platform_utils.dart';
import 'dart:ui';

import 'main_layout.dart';
import 'providers/web_rtc_client.dart';
import 'tasks/background_tasks_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final log = Logger('ocu_ui');

  // Load config
  final configString = await rootBundle.loadString('assets/config.json');
  final configJson = jsonDecode(configString);
  final appConfig = AppConfig.fromJson(configJson);

  log.info('Current working directory: ${PlatformUtils.currentDirectory}');
  log.info(
    'Loaded config: workingDir=${appConfig.workingDirectory}, webRtcUrl=${appConfig.webRtcUrl}',
  );

  WebRTCClient().connect(appConfig.webRtcUrl, appConfig.retryWebRTCConnect);
  BackgroundTasksManager.startAll();

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(appConfig)],
      child: const MyApp(),
    ),
  );
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
