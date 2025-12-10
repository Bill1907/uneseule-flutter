/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Uneseule';
  static const String appNameKorean = '윤슬';

  // Bluetooth
  static const String dollDeviceName = '윤슬';
  static const int bluetoothScanDuration = 10; // seconds
  static const int bluetoothReconnectInterval = 3; // seconds
  static const double bluetoothMaxRange = 10.0; // meters

  // WebRTC
  static const int webrtcConnectTimeout = 30; // seconds
  static const List<String> stunServers = [
    'stun:stun.l.google.com:19302',
  ];

  // Audio
  static const int audioSampleRate = 16000; // Hz
  static const String audioCodec = 'mSBC';
  static const int targetLatency = 1200; // milliseconds (P95)

  // Safety
  static const List<String> forbiddenKeywords = [
    '때리다',
    '죽다',
    // Add more forbidden keywords
  ];

  // API
  static const int apiConnectTimeout = 30; // seconds
  static const int apiReceiveTimeout = 30; // seconds

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
