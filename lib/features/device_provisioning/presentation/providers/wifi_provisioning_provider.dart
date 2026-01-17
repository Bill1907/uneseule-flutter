import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/wifi_status.dart';
import 'device_providers.dart';

part 'wifi_provisioning_provider.g.dart';

/// WiFi Provisioning 상태 관리 Provider
@riverpod
class WifiProvisioning extends _$WifiProvisioning {
  @override
  AsyncValue<WifiStatus> build() => AsyncData(WifiStatus.initial());

  /// WiFi Provisioning 시작
  /// 30초 타임아웃 후 자동으로 실패 처리
  Future<void> provision(WifiCredentials credentials) async {
    state = AsyncData(
      const WifiStatus(state: WifiConnectionState.connecting),
    );

    try {
      final useCase = ref.read(provisionWifiUseCaseProvider);
      await useCase.call(credentials);

      // WiFi 상태 스트림 구독 (30초 타임아웃)
      const timeout = Duration(seconds: 30);

      await for (final status in useCase.statusStream.timeout(
        timeout,
        onTimeout: (sink) {
          // 타임아웃 시 스트림 종료
          sink.close();
        },
      )) {
        state = AsyncData(status);

        // 최종 상태에 도달하면 중지
        if (status.state == WifiConnectionState.connected ||
            status.state == WifiConnectionState.failed ||
            status.state == WifiConnectionState.wrongPassword ||
            status.state == WifiConnectionState.noAccessPoint) {
          break;
        }
      }

      // 타임아웃으로 스트림 종료된 경우 체크
      final currentState = state.valueOrNull;
      if (currentState != null &&
          currentState.state == WifiConnectionState.connecting) {
        state = const AsyncData(WifiStatus(
          state: WifiConnectionState.failed,
          errorMessage: '연결 시간이 초과되었습니다. 다시 시도해주세요.',
        ));
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Provisioning 취소
  Future<void> cancel() async {
    await ref.read(provisionWifiUseCaseProvider).cancel();
    state = AsyncData(WifiStatus.initial());
  }

  /// 상태 초기화
  void reset() {
    state = AsyncData(WifiStatus.initial());
  }
}

/// WiFi 상태 스트림 Provider
@riverpod
Stream<WifiStatus> wifiStatusStream(Ref ref) {
  return ref.watch(provisionWifiUseCaseProvider).statusStream;
}
