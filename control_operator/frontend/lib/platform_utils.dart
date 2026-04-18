// platform_utils.dart

import 'platform_utils_io.dart'
    if (dart.library.js_interop) 'platform_utils_web.dart';

abstract class PlatformUtils {
  static String get currentDirectory => getCurrentDirectory();
  static void exitApp(int code) => exitApplication(code);
}
