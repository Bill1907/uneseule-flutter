import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/device_info.dart';
import 'device_providers.dart';

part 'device_connection_provider.g.dart';

/// 디바이스 연결 상태 Enum
enum DeviceConnectionState {
  /// 연결 해제됨
  disconnected,

  /// 연결 중
  connecting,

  /// 연결됨
  connected,

  /// 연결 오류
  error,
}

/// 디바이스 연결 상태 관리 Provider
@riverpod
class DeviceConnection extends _$DeviceConnection {
  @override
  DeviceConnectionState build() => DeviceConnectionState.disconnected;

  /// 디바이스 연결
  Future<void> connect(String deviceId) async {
    state = DeviceConnectionState.connecting;

    try {
      await ref.read(connectDeviceUseCaseProvider).call(deviceId);
      state = DeviceConnectionState.connected;
    } catch (e) {
      state = DeviceConnectionState.error;
      rethrow;
    }
  }

  /// 디바이스 연결 해제
  Future<void> disconnect() async {
    await ref.read(connectDeviceUseCaseProvider).disconnect();
    state = DeviceConnectionState.disconnected;
  }
}

/// 연결 상태 스트림 Provider
@riverpod
Stream<bool> connectionStatus(Ref ref) {
  return ref.watch(connectDeviceUseCaseProvider).connectionState;
}

/// 연결된 디바이스 정보 관리 Provider
@riverpod
class ConnectedDeviceInfo extends _$ConnectedDeviceInfo {
  @override
  AsyncValue<DeviceInfo?> build() => const AsyncData(null);

  /// 디바이스 정보 로드
  Future<void> loadDeviceInfo() async {
    state = const AsyncLoading();

    try {
      final deviceInfo = await ref.read(readDeviceInfoUseCaseProvider).call();
      state = AsyncData(deviceInfo);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 디바이스 정보 초기화
  void clear() {
    state = const AsyncData(null);
  }
}

/// 배터리 레벨 스트림 Provider
@riverpod
Stream<int> batteryLevel(Ref ref) {
  return ref.watch(readDeviceInfoUseCaseProvider).batteryLevel;
}
