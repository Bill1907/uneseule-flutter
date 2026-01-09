import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/wifi_status.dart';
import '../providers/device_connection_provider.dart';
import '../providers/wifi_provisioning_provider.dart';
import '../widgets/wifi_form.dart';
import '../widgets/connection_status_indicator.dart';

/// WiFi 설정 화면
class WifiSetupScreen extends ConsumerWidget {
  const WifiSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provisioningState = ref.watch(wifiProvisioningProvider);
    final theme = Theme.of(context);

    // 연결 성공 시 완료 화면으로 이동
    ref.listen<AsyncValue<WifiStatus>>(wifiProvisioningProvider, (prev, next) {
      next.whenData((status) {
        if (status.state == WifiConnectionState.connected) {
          context.go('/device-provisioning/complete');
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await ref.read(deviceConnectionProvider.notifier).disconnect();
            if (context.mounted) context.go('/device-provisioning');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: provisioningState.when(
            data: (status) {
              // 연결 중 상태
              if (status.state == WifiConnectionState.connecting) {
                return Column(
                  children: [
                    const SizedBox(height: 64),
                    ConnectionStatusIndicator(status: status),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () {
                        ref.read(wifiProvisioningProvider.notifier).cancel();
                      },
                      child: const Text('취소'),
                    ),
                  ],
                );
              }

              // 에러 상태 (재시도 가능)
              if (status.state == WifiConnectionState.failed ||
                  status.state == WifiConnectionState.wrongPassword ||
                  status.state == WifiConnectionState.noAccessPoint) {
                return Column(
                  children: [
                    const SizedBox(height: 32),
                    ConnectionStatusIndicator(status: status),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 32),
                    Text(
                      '다시 시도해주세요',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    WifiForm(
                      onSubmit: (ssid, password) {
                        ref.read(wifiProvisioningProvider.notifier).provision(
                              WifiCredentials(ssid: ssid, password: password),
                            );
                      },
                    ),
                  ],
                );
              }

              // 기본 상태 (입력 폼)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더
                  Text(
                    'WiFi 네트워크 연결',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '디바이스가 인터넷에 연결되어야\n음성 AI 기능을 사용할 수 있습니다.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // WiFi 입력 폼
                  WifiForm(
                    onSubmit: (ssid, password) {
                      ref.read(wifiProvisioningProvider.notifier).provision(
                            WifiCredentials(ssid: ssid, password: password),
                          );
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('오류: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(wifiProvisioningProvider.notifier).reset();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
