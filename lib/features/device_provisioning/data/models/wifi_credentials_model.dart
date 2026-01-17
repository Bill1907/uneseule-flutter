import 'dart:convert';

import '../../domain/entities/wifi_status.dart';
import '../../../../core/constants/ble_constants.dart';

/// WiFi 인증 정보 데이터 모델
class WifiCredentialsModel {
  final String ssid;
  final String password;

  WifiCredentialsModel({
    required this.ssid,
    required this.password,
  });

  /// Domain Entity에서 모델 생성
  factory WifiCredentialsModel.fromEntity(WifiCredentials entity) {
    return WifiCredentialsModel(
      ssid: entity.ssid,
      password: entity.password,
    );
  }

  /// SSID를 바이트 배열로 변환 (NULL 문자 제거)
  /// ESP32 C 문자열 호환성을 위해 NULL 문자(0x00)를 필터링
  List<int> get ssidBytes {
    final bytes = utf8.encode(ssid);
    return bytes.where((b) => b != 0).toList();
  }

  /// 비밀번호를 바이트 배열로 변환 (NULL 문자 제거)
  /// ESP32 C 문자열 호환성을 위해 NULL 문자(0x00)를 필터링
  List<int> get passwordBytes {
    final bytes = utf8.encode(password);
    return bytes.where((b) => b != 0).toList();
  }
}

/// WiFi 상태 데이터 모델
class WifiStatusModel {
  final int statusCode;
  final String? ssid;
  final String? ipAddress;

  WifiStatusModel({
    required this.statusCode,
    this.ssid,
    this.ipAddress,
  });

  /// BLE 바이트 데이터에서 모델 생성
  /// Protocol: [status_code, ssid_len, ssid..., ip_len, ip...]
  factory WifiStatusModel.fromBytes(List<int> bytes) {
    if (bytes.isEmpty) {
      return WifiStatusModel(statusCode: BleConstants.wifiStatusDisconnected);
    }

    final statusCode = bytes[0];
    String? ssid;
    String? ipAddress;

    if (bytes.length > 2) {
      // ssidLen을 unsigned로 처리하고 최대 32바이트로 제한
      final ssidLen = bytes[1] & 0xFF;
      final clampedSsidLen = ssidLen > 32 ? 32 : ssidLen;

      if (clampedSsidLen > 0 && bytes.length >= 2 + clampedSsidLen) {
        try {
          ssid = utf8.decode(bytes.sublist(2, 2 + clampedSsidLen));
        } catch (_) {
          // UTF-8 디코딩 실패 시 무시
        }

        final ipStart = 2 + clampedSsidLen;
        if (bytes.length > ipStart) {
          // ipLen을 unsigned로 처리하고 최대 15바이트로 제한 (xxx.xxx.xxx.xxx)
          final ipLen = bytes[ipStart] & 0xFF;
          final clampedIpLen = ipLen > 15 ? 15 : ipLen;

          if (clampedIpLen > 0 && bytes.length >= ipStart + 1 + clampedIpLen) {
            try {
              ipAddress = utf8.decode(bytes.sublist(ipStart + 1, ipStart + 1 + clampedIpLen));
            } catch (_) {
              // UTF-8 디코딩 실패 시 무시
            }
          }
        }
      }
    }

    return WifiStatusModel(
      statusCode: statusCode,
      ssid: ssid,
      ipAddress: ipAddress,
    );
  }

  /// Domain Entity로 변환
  WifiStatus toEntity() {
    return WifiStatus(
      state: _codeToState(statusCode),
      ssid: ssid,
      ipAddress: ipAddress,
      errorMessage: _getErrorMessage(),
    );
  }

  /// 상태 코드를 Enum으로 변환
  WifiConnectionState _codeToState(int code) {
    switch (code) {
      case BleConstants.wifiStatusDisconnected:
        return WifiConnectionState.disconnected;
      case BleConstants.wifiStatusConnecting:
        return WifiConnectionState.connecting;
      case BleConstants.wifiStatusConnected:
        return WifiConnectionState.connected;
      case BleConstants.wifiStatusFailed:
        return WifiConnectionState.failed;
      case BleConstants.wifiStatusWrongPassword:
        return WifiConnectionState.wrongPassword;
      case BleConstants.wifiStatusNoAp:
        return WifiConnectionState.noAccessPoint;
      default:
        return WifiConnectionState.failed;
    }
  }

  /// 에러 메시지 생성
  String? _getErrorMessage() {
    switch (statusCode) {
      case BleConstants.wifiStatusFailed:
        return '연결에 실패했습니다';
      case BleConstants.wifiStatusWrongPassword:
        return '비밀번호가 올바르지 않습니다';
      case BleConstants.wifiStatusNoAp:
        return 'WiFi 네트워크를 찾을 수 없습니다';
      default:
        return null;
    }
  }
}
