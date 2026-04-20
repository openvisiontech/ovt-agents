import 'process_action_requests.dart';
import 'process_media_requests.dart';
import 'process_chat.dart';
import 'process_stream.dart';
import 'process_gamepad.dart';
import 'expire_stream_data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundTasksManager {
  static Future<void> startAll(ProviderContainer container) async {
    processActionRequests(container);
    processMediaRequests(container);
    processChat(container);
    processStream(container);
    processGamepad(container);
    expireStreamData(container);
  }

  static void stopAll() {
    // Tasks run asynchronously on main loop and will naturally close on application exit.
  }
}
