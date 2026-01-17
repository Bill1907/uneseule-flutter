/// 표준화된 Bridge 에러 코드
enum BridgeErrorCode {
  // 일반 에러 (1000번대)
  unknownError(1000, '알 수 없는 오류'),
  methodNotFound(1001, '메서드를 찾을 수 없음'),
  invalidParams(1002, '잘못된 파라미터'),
  timeout(1003, '요청 타임아웃'),

  // BLE 에러 (2000번대)
  bluetoothDisabled(2000, 'Bluetooth 비활성화'),
  notConnected(2001, '디바이스 미연결'),
  scanFailed(2002, '스캔 실패'),
  connectionFailed(2003, '연결 실패'),
  deviceNotFound(2004, '디바이스를 찾을 수 없음'),
  serviceNotFound(2005, '서비스를 찾을 수 없음'),

  // WiFi 에러 (3000번대)
  wifiProvisioningFailed(3000, 'WiFi 설정 실패'),
  invalidSsid(3001, '잘못된 SSID'),
  invalidPassword(3002, '잘못된 비밀번호'),

  // 권한 에러 (4000번대)
  permissionDenied(4000, '권한 거부됨'),
  permissionPermanentlyDenied(4001, '권한 영구 거부됨');

  final int code;
  final String defaultMessage;

  const BridgeErrorCode(this.code, this.defaultMessage);
}

/// Bridge 관련 예외 기본 클래스
abstract class BridgeException implements Exception {
  BridgeErrorCode get errorCode;
  String get message;

  /// 에러를 JSON 형태로 변환
  Map<String, dynamic> toJson() => {
        'code': errorCode.code,
        'name': errorCode.name,
        'message': message,
      };

  @override
  String toString() => 'BridgeException: $message';
}

/// Bridge 요청 타임아웃
class BridgeTimeoutException extends BridgeException {
  final String method;
  final Duration timeout;

  BridgeTimeoutException(this.method, this.timeout);

  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.timeout;

  @override
  String get message =>
      '$method 요청이 ${timeout.inSeconds}초 후 타임아웃되었습니다';
}

/// 알 수 없는 메서드 호출
class BridgeMethodNotFoundException extends BridgeException {
  final String method;

  BridgeMethodNotFoundException(this.method);

  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.methodNotFound;

  @override
  String get message => '알 수 없는 메서드: $method';
}

/// BLE 연결되지 않음
class BleNotConnectedException extends BridgeException {
  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.notConnected;

  @override
  String get message => '디바이스에 연결되지 않았습니다';
}

/// BLE 스캔 실패
class BleScanFailedException extends BridgeException {
  final String? originalError;

  BleScanFailedException([this.originalError]);

  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.scanFailed;

  @override
  String get message => '스캔 실패: ${originalError ?? "알 수 없는 오류"}';
}

/// BLE 연결 실패
class BleConnectionFailedException extends BridgeException {
  final String deviceId;
  final String? originalError;

  BleConnectionFailedException(this.deviceId, [this.originalError]);

  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.connectionFailed;

  @override
  String get message =>
      '디바이스 연결 실패 ($deviceId): ${originalError ?? "알 수 없는 오류"}';
}

/// WiFi Provisioning 실패
class WifiProvisioningFailedException extends BridgeException {
  final String? originalError;

  WifiProvisioningFailedException([this.originalError]);

  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.wifiProvisioningFailed;

  @override
  String get message =>
      'WiFi 설정 실패: ${originalError ?? "알 수 없는 오류"}';
}

/// 권한 거부 예외
class PermissionDeniedException extends BridgeException {
  final bool isPermanent;

  PermissionDeniedException({this.isPermanent = false});

  @override
  BridgeErrorCode get errorCode => isPermanent
      ? BridgeErrorCode.permissionPermanentlyDenied
      : BridgeErrorCode.permissionDenied;

  @override
  String get message =>
      isPermanent ? '권한이 영구적으로 거부되었습니다. 설정에서 변경해주세요.' : '권한이 거부되었습니다';
}

/// Bluetooth 비활성화 예외
class BluetoothDisabledException extends BridgeException {
  @override
  BridgeErrorCode get errorCode => BridgeErrorCode.bluetoothDisabled;

  @override
  String get message => 'Bluetooth가 비활성화되어 있습니다';
}
