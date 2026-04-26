/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..

 * Open Vision Technology, LLC. and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto. Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from Open Vision Technology, LLC. is strictly prohibited.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **********************************************************************************
 */

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
