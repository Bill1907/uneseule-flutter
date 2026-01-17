import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/device_scan_provider.dart';
import '../widgets/device_list_item.dart';

/// 디바이스 스캔 화면
class DeviceScanScreen extends ConsumerStatefulWidget {
  const DeviceScanScreen({super.key});

  @override
  ConsumerState<DeviceScanScreen> createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends ConsumerState<DeviceScanScreen> {
  bool _isCheckingPermission = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndScan();
  }

  Future<void> _checkPermissionsAndScan() async {
    setState(() => _isCheckingPermission = true);

    // Bluetooth 권한 확인
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    final hasPermission = bluetoothScan.isGranted &&
        bluetoothConnect.isGranted &&
        location.isGranted;

    setState(() {
      _isCheckingPermission = false;
      _hasPermission = hasPermission;
    });

    if (hasPermission) {
      ref.read(deviceScanProvider.notifier).startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(deviceScanProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('디바이스 검색'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _hasPermission
                ? () => ref.read(deviceScanProvider.notifier).refresh()
                : null,
            tooltip: '다시 검색',
          ),
        ],
      ),
      body: _isCheckingPermission
          ? const Center(child: CircularProgressIndicator())
          : !_hasPermission
              ? _buildPermissionDenied(theme)
              : scanState.when(
                  data: (devices) => _buildDeviceList(devices, theme),
                  loading: () => _buildScanning(theme),
                  error: (error, _) => _buildError(error, theme),
                ),
    );
  }

  /// 권한 거부 UI
  Widget _buildPermissionDenied(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_disabled,
              size: 64,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              '블루투스 권한이 필요합니다',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Uneseule 디바이스를 검색하려면\n블루투스 및 위치 권한이 필요합니다.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _checkPermissionsAndScan,
              icon: const Icon(Icons.settings),
              label: const Text('권한 허용하기'),
            ),
          ],
        ),
      ),
    );
  }

  /// 스캔 중 UI
  Widget _buildScanning(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 24),
          Text(
            '주변에서 디바이스를 검색 중...',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Uneseule 디바이스의 전원이 켜져 있는지 확인하세요',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 디바이스 목록 UI
  Widget _buildDeviceList(List devices, ThemeData theme) {
    if (devices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: theme.disabledColor,
              ),
              const SizedBox(height: 16),
              Text(
                '디바이스를 찾을 수 없습니다',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Uneseule 디바이스가 근처에 있고\n전원이 켜져 있는지 확인하세요',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => ref.read(deviceScanProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('다시 검색'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return DeviceListItem(
          device: device,
          onTap: () => _onDeviceTap(device.id),
        );
      },
    );
  }

  /// 에러 UI
  Widget _buildError(Object error, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '오류가 발생했습니다',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(deviceScanProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  void _onDeviceTap(String deviceId) {
    ref.read(deviceScanProvider.notifier).stopScan();
    context.push('/device-provisioning/connect/$deviceId');
  }
}
