import 'process_action_requests.dart';
import 'process_media_requests.dart';
import 'process_chat.dart';
import 'process_stream.dart';
import 'process_gamepad.dart';
import 'expire_stream_data.dart';

class BackgroundTasksManager {
  static Future<void> startAll() async {
    processActionRequests(null);
    processMediaRequests(null);
    processChat(null);
    processStream(null);
    processGamepad(null);
    expireStreamData(null);
  }

  static void stopAll() {
    // Tasks run asynchronously on main loop and will naturally close on application exit.
  }
}
