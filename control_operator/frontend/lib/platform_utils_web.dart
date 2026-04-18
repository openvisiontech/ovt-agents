// platform_utils_web.dart

String getCurrentDirectory() {
  // Web doesn't have a file system current directory
  return '/';
}

void exitApplication(int code) {
  // Web apps don't restart/exit usually
  print('Application exit requested with code $code');
}
