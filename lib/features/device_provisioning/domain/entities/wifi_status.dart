import 'package:freezed_annotation/freezed_annotation.dart';

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
  const factory WifiCredentials({
    /// WiFi 네트워크 이름
    required String ssid,

    /// WiFi 비밀번호
    required String password,
  }) = _WifiCredentials;
}
