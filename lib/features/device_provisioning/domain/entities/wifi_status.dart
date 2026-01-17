import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/wifi_exceptions.dart';

part 'wifi_status.freezed.dart';

/// WiFi 연결 상태
enum WifiConnectionState {
  /// 연결 해제됨
  disconnected,

  /// 연결 중
  connecting,

  /// 연결 완료
  connected,

  /// 연결 실패
  failed,

  /// 비밀번호 오류
  wrongPassword,

  /// AP를 찾을 수 없음
  noAccessPoint,
}

/// WiFi 상태 정보
@freezed
class WifiStatus with _$WifiStatus {
  const factory WifiStatus({
    /// 연결 상태
    required WifiConnectionState state,

    /// 연결된 SSID
    String? ssid,

    /// 할당된 IP 주소
    String? ipAddress,

    /// 에러 메시지
    String? errorMessage,
  }) = _WifiStatus;

  /// 초기 상태
  factory WifiStatus.initial() => const WifiStatus(
        state: WifiConnectionState.disconnected,
      );
}

/// WiFi 인증 정보
@freezed
class WifiCredentials with _$WifiCredentials {
  const WifiCredentials._();

  const factory WifiCredentials({
    /// WiFi 네트워크 이름
    required String ssid,

    /// WiFi 비밀번호
    required String password,
  }) = _WifiCredentials;

  /// 검증된 WiFi 인증 정보 생성
  /// [ssid]: 1-32 바이트 (빈 값 불허)
  /// [password]: 0바이트(오픈 네트워크) 또는 8-63 바이트 (WPA2)
  factory WifiCredentials.validated({
    required String ssid,
    required String password,
  }) {
    // SSID 검증
    if (ssid.trim().isEmpty) {
      throw const EmptySsidException();
    }

    final ssidBytes = utf8.encode(ssid);
    if (ssidBytes.length > 32) {
      throw SsidTooLongException(actualLength: ssidBytes.length);
    }

    // 비밀번호 검증 (빈 값은 오픈 네트워크)
    final passwordBytes = utf8.encode(password);
    if (password.isNotEmpty) {
      if (passwordBytes.length < 8) {
        throw PasswordTooShortException(actualLength: passwordBytes.length);
      }
      if (passwordBytes.length > 63) {
        throw PasswordTooLongException(actualLength: passwordBytes.length);
      }
    }

    return WifiCredentials(ssid: ssid, password: password);
  }
}
