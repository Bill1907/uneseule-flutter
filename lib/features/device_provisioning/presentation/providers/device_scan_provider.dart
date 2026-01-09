import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/device_info.dart';
import 'device_providers.dart';

part 'device_scan_provider.g.dart';

/// 디바이스 스캔 상태 관리 Provider
@riverpod
class DeviceScan extends _$DeviceScan {
  @override
  AsyncValue<List<ScannedDevice>> build() {
    return const AsyncData([]);
  }

  /// 스캔 시작
  Future<void> startScan() async {
    state = const AsyncLoading();

    try {
      final useCase = ref.read(scanDevicesUseCaseProvider);

      await for (final devices in useCase()) {
        state = AsyncData(devices);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 스캔 중지
  Future<void> stopScan() async {
    await ref.read(scanDevicesUseCaseProvider).stop();
  }

  /// 스캔 재시작
  Future<void> refresh() async {
    await stopScan();
    await startScan();
  }
}
