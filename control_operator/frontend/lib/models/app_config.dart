class AppConfig {
  final String workingDirectory;
  final String webRtcUrl;
  final int retryWebRTCConnect;
  final bool defaultProvider;

  const AppConfig({
    required this.workingDirectory,
    required this.webRtcUrl,
    required this.retryWebRTCConnect,
    this.defaultProvider = false,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      workingDirectory:
          json['workingDirectory'] as String? ?? '/home/ovt/uli_deploy',
      webRtcUrl: json['webRtcUrl'] as String? ?? 'ws://127.0.0.1:8080/ws/rtc',
      retryWebRTCConnect: json['retryWebRTCConnect'] as int? ?? 5000,
      defaultProvider: json['defaultProvider'] as bool? ?? false,
    );
  }
}
