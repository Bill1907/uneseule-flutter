/// BLE GATT Service 및 Characteristic UUID 정의
/// ESP32-S3 디바이스와의 통신에 사용
class BleConstants {
  BleConstants._();

  // === Device Name ===
  /// 스캔 필터용 디바이스 이름 접두사
  static const String deviceNamePrefix = 'Uneseule-';

  // === Timeouts ===
  /// BLE 스캔 타임아웃
  static const Duration scanTimeout = Duration(seconds: 15);

  /// BLE 연결 타임아웃
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// 서비스 검색 후 안정화 대기 시간
  static const Duration serviceDiscoveryDelay = Duration(milliseconds: 500);

  // === Standard Services (SIG 표준) ===

  /// Device Information Service UUID
  static const String deviceInfoServiceUuid = '180A';

  /// Manufacturer Name Characteristic (MAC Address로 사용)
  static const String manufacturerNameCharUuid = '2A29';

  /// Firmware Revision Characteristic
  static const String firmwareRevisionCharUuid = '2A26';

  /// Battery Service UUID
  static const String batteryServiceUuid = '180F';

  /// Battery Level Characteristic
  static const String batteryLevelCharUuid = '2A19';

  // === Custom Services (ESP32 전용) ===

  /// WiFi Provisioning Service UUID
  static const String wifiProvServiceUuid =
      '12345678-1234-5678-1234-56789abcdef0';

  /// WiFi SSID Characteristic (Write)
  static const String wifiSsidCharUuid =
      '12345678-1234-5678-1234-56789abcdef1';

  /// WiFi Password Characteristic (Write)
  static const String wifiPasswordCharUuid =
      '12345678-1234-5678-1234-56789abcdef2';

  /// WiFi Status Characteristic (Read/Notify)
  static const String wifiStatusCharUuid =
      '12345678-1234-5678-1234-56789abcdef3';

  /// Provisioning Command Characteristic (Write)
  static const String provisioningCommandCharUuid =
      '12345678-1234-5678-1234-56789abcdef4';

  /// Device Secret Key Characteristic (Read)
  static const String deviceSecretKeyCharUuid =
      '12345678-1234-5678-1234-56789abcdef5';

  // === WiFi Status Codes ===
  /// WiFi 연결 해제됨
  static const int wifiStatusDisconnected = 0;

  /// WiFi 연결 중
  static const int wifiStatusConnecting = 1;

  /// WiFi 연결 완료
  static const int wifiStatusConnected = 2;

  /// WiFi 연결 실패
  static const int wifiStatusFailed = 3;

  /// WiFi 비밀번호 오류
  static const int wifiStatusWrongPassword = 4;

  /// WiFi AP를 찾을 수 없음
  static const int wifiStatusNoAp = 5;

  // === Provisioning Commands ===
  /// Provisioning 시작 명령
  static const int cmdStartProvisioning = 0x01;

  /// Provisioning 중지 명령
  static const int cmdStopProvisioning = 0x02;

  /// 디바이스 리셋 명령
  static const int cmdResetDevice = 0xFF;
}
