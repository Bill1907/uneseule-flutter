import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/device_info.dart';
import '../providers/device_connection_provider.dart';

/// 디바이스 연결 화면
class DeviceConnectScreen extends ConsumerStatefulWidget {
  final String deviceId;

  const DeviceConnectScreen({
    super.key,
    required this.deviceId,
  });

  @override
  ConsumerState<DeviceConnectScreen> createState() =>
      _DeviceConnectScreenState();
}

class _DeviceConnectScreenState extends ConsumerState<DeviceConnectScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connect();
    });
  }

  Future<void> _connect() async {
    setState(() => _errorMessage = null);

    try {
      await ref.read(deviceConnectionProvider.notifier).connect(widget.deviceId);
      await ref.read(connectedDeviceInfoProvider.notifier).loadDeviceInfo();

      if (mounted) {
        // WiFi 설정 화면으로 이동
        context.go('/device-provisioning/wifi-setup');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(deviceConnectionProvider);
    final deviceInfo = ref.watch(connectedDeviceInfoProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('디바이스 연결'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await ref.read(deviceConnectionProvider.notifier).disconnect();
            if (!context.mounted) return;
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 연결 중
              if (connectionState == DeviceConnectionState.connecting) ...[
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(height: 24),
                Text(
                  '디바이스에 연결 중...',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '잠시만 기다려주세요',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ]

              // 연결 완료
              else if (connectionState == DeviceConnectionState.connected) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '연결 완료!',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                deviceInfo.when(
                  data: (info) =>
                      info != null ? _buildDeviceInfo(info, theme) : const SizedBox(),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(
                    '디바이스 정보 로드 실패: $e',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ]

              // 연결 오류
              else if (connectionState == DeviceConnectionState.error ||
                  _errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error,
                    size: 64,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '연결 실패',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? '디바이스에 연결할 수 없습니다',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _connect,
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(DeviceInfo info, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(theme, Icons.devices, '이름', info.name),
            const SizedBox(height: 8),
            _buildInfoRow(theme, Icons.memory, 'MAC', info.macAddress),
            const SizedBox(height: 8),
            _buildInfoRow(theme, Icons.system_update, '펌웨어', info.firmwareVersion),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme,
              Icons.battery_charging_full,
              '배터리',
              '${info.batteryLevel}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.hintColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
