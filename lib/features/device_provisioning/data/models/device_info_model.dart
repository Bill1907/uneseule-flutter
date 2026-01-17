import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/device_info.dart';

part 'device_info_model.freezed.dart';
part 'device_info_model.g.dart';

/// 디바이스 정보 데이터 모델
@freezed
class DeviceInfoModel with _$DeviceInfoModel {
  const DeviceInfoModel._();

  const factory DeviceInfoModel({
    required String id,
    required String name,
    required String macAddress,
    required String firmwareVersion,
    required int batteryLevel,
    String? secretKey,
    required int rssi,
  }) = _DeviceInfoModel;

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);

  /// BLE Characteristic 바이트 데이터에서 모델 생성
  factory DeviceInfoModel.fromBleData({
    required String id,
    required String name,
    required List<int> macAddressBytes,
    required List<int> firmwareBytes,
    required int batteryLevel,
    List<int>? secretKeyBytes,
    required int rssi,
  }) {
    return DeviceInfoModel(
      id: id,
      name: name,
      macAddress: _bytesToMacAddress(macAddressBytes),
      firmwareVersion: _bytesToString(firmwareBytes),
      batteryLevel: batteryLevel.clamp(0, 100),
      secretKey: secretKeyBytes != null ? _bytesToString(secretKeyBytes) : null,
      rssi: rssi,
    );
  }

  /// Domain Entity로 변환
  DeviceInfo toEntity() => DeviceInfo(
        id: id,
        name: name,
        macAddress: macAddress,
        firmwareVersion: firmwareVersion,
        batteryLevel: batteryLevel,
        secretKey: secretKey,
        rssi: rssi,
      );

  /// 바이트 배열을 MAC 주소 문자열로 변환
  static String _bytesToMacAddress(List<int> bytes) {
    if (bytes.isEmpty) return 'Unknown';
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
  }

  /// 바이트 배열을 UTF-8 문자열로 변환
  static String _bytesToString(List<int> bytes) {
    if (bytes.isEmpty) return '';
    try {
      // NULL 문자 제거
      final cleanBytes = bytes.where((b) => b != 0).toList();
      return utf8.decode(cleanBytes);
    } catch (e) {
      return String.fromCharCodes(bytes);
    }
  }
}
