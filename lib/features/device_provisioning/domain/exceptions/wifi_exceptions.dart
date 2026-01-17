// WiFi 관련 예외 클래스들

/// WiFi 인증 정보 검증 예외의 기본 클래스
abstract class WifiCredentialsException implements Exception {
  final String message;
  const WifiCredentialsException(this.message);

  @override
  String toString() => message;
}

/// SSID가 비어있을 때 발생하는 예외
class EmptySsidException extends WifiCredentialsException {
  const EmptySsidException() : super('SSID를 입력해주세요.');
}

/// SSID가 너무 길 때 발생하는 예외 (최대 32바이트)
class SsidTooLongException extends WifiCredentialsException {
  final int actualLength;
  final int maxLength;

  const SsidTooLongException({
    required this.actualLength,
    this.maxLength = 32,
  }) : super('SSID가 너무 깁니다. (최대 32바이트)');
}

/// 비밀번호가 너무 길 때 발생하는 예외 (최대 63바이트)
class PasswordTooLongException extends WifiCredentialsException {
  final int actualLength;
  final int maxLength;

  const PasswordTooLongException({
    required this.actualLength,
    this.maxLength = 63,
  }) : super('비밀번호가 너무 깁니다. (최대 63자)');
}

/// 비밀번호가 너무 짧을 때 발생하는 예외 (최소 8바이트, WPA2)
class PasswordTooShortException extends WifiCredentialsException {
  final int actualLength;
  final int minLength;

  const PasswordTooShortException({
    required this.actualLength,
    this.minLength = 8,
  }) : super('비밀번호는 최소 8자 이상이어야 합니다.');
}
