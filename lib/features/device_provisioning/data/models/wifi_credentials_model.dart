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

  /// SSID를 바이트 배열로 변환
  List<int> get ssidBytes => utf8.encode(ssid);

  /// 비밀번호를 바이트 배열로 변환
  List<int> get passwordBytes => utf8.encode(password);
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
      final ssidLen = bytes[1];
      if (ssidLen > 0 && bytes.length > 2 + ssidLen) {
        try {
          ssid = utf8.decode(bytes.sublist(2, 2 + ssidLen));
        } catch (_) {
          // UTF-8 디코딩 실패 시 무시
        }

        final ipStart = 2 + ssidLen;
        if (bytes.length > ipStart + 1) {
          final ipLen = bytes[ipStart];
          if (ipLen > 0 && bytes.length >= ipStart + 1 + ipLen) {
            try {
              ipAddress = utf8.decode(bytes.sublist(ipStart + 1, ipStart + 1 + ipLen));
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
