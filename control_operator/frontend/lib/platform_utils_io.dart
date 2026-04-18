// platform_utils_io.dart

import 'dart:io';

String getCurrentDirectory() {
  return Directory.current.path;
}

void exitApplication(int code) {
  exit(code);
}
