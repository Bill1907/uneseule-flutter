import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/device_info.dart';
import '../providers/device_connection_provider.dart';

/// Provisioning 완료 화면
class ProvisioningCompleteScreen extends ConsumerWidget {
  const ProvisioningCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInfo = ref.watch(connectedDeviceInfoProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(),

              // 성공 아이콘
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),

              // 타이틀
              Text(
                '설정 완료!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 설명
              Text(
                'Uneseule 디바이스가 성공적으로 설정되었습니다.\n이제 음성 AI 기능을 사용할 수 있습니다.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 디바이스 정보 카드
              deviceInfo.when(
                data: (info) =>
                    info != null ? _buildDeviceCard(info, theme) : const SizedBox(),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

              const Spacer(),

              // 시작 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // BLE 연결 해제
                    await ref.read(deviceConnectionProvider.notifier).disconnect();
                    // 디바이스 정보 초기화
                    ref.read(connectedDeviceInfoProvider.notifier).clear();

                    if (context.mounted) {
                      // 홈 화면으로 이동 (추후 대화 화면으로 변경)
                      context.go('/device-provisioning');
                    }
                  },
                  child: const Text(
                    '시작하기',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 다른 디바이스 추가 버튼
              TextButton(
                onPressed: () async {
                  await ref.read(deviceConnectionProvider.notifier).disconnect();
                  ref.read(connectedDeviceInfoProvider.notifier).clear();

                  if (context.mounted) {
                    context.go('/device-provisioning');
                  }
                },
                child: const Text('다른 디바이스 연결하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(DeviceInfo info, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 디바이스 아이콘
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.toys,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // 디바이스 이름
            Text(
              info.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 디바이스 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoColumn(
                  theme,
                  Icons.memory,
                  'MAC',
                  _formatMac(info.macAddress),
                ),
                _buildInfoColumn(
                  theme,
                  Icons.system_update,
                  '펌웨어',
                  info.firmwareVersion,
                ),
                _buildInfoColumn(
                  theme,
                  Icons.battery_full,
                  '배터리',
                  '${info.batteryLevel}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.hintColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// MAC 주소 포맷팅 (마지막 4자리만 표시)
  String _formatMac(String mac) {
    final parts = mac.split(':');
    if (parts.length >= 2) {
      return '...${parts[parts.length - 2]}:${parts[parts.length - 1]}';
    }
    return mac;
  }
}
