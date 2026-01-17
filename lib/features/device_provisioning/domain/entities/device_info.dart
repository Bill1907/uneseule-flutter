import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';

/// 연결된 디바이스의 상세 정보
@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    /// BLE remoteId
    required String id,

    /// 디바이스 이름 (예: Uneseule-001)
    required String name,

    /// MAC 주소
    required String macAddress,

    /// 펌웨어 버전
    required String firmwareVersion,

    /// 배터리 잔량 (0-100%)
    required int batteryLevel,

    /// 디바이스 고유 인증키
    String? secretKey,

    /// BLE 신호 강도 (RSSI)
    required int rssi,
  }) = _DeviceInfo;
}

/// 스캔된 디바이스 (연결 전 정보)
@freezed
class ScannedDevice with _$ScannedDevice {
  const factory ScannedDevice({
    /// BLE remoteId
    required String id,

    /// 디바이스 이름
    required String name,

    /// BLE 신호 강도 (RSSI)
    required int rssi,

    /// 연결 가능 여부
    required bool isConnectable,
  }) = _ScannedDevice;
}
