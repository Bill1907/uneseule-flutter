import 'package:flutter/material.dart';

import '../../domain/entities/device_info.dart';

/// 스캔된 디바이스 목록 아이템 위젯
class DeviceListItem extends StatelessWidget {
  final ScannedDevice device;
  final VoidCallback onTap;

  const DeviceListItem({
    super.key,
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getSignalColor(device.rssi).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.bluetooth,
            color: _getSignalColor(device.rssi),
            size: 28,
          ),
        ),
        title: Text(
          device.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              _getSignalIcon(device.rssi),
              size: 16,
              color: _getSignalColor(device.rssi),
            ),
            const SizedBox(width: 4),
            Text(
              _getSignalText(device.rssi),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getSignalColor(device.rssi),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: device.isConnectable
              ? theme.colorScheme.primary
              : theme.disabledColor,
        ),
        onTap: device.isConnectable ? onTap : null,
        enabled: device.isConnectable,
      ),
    );
  }

  /// 신호 강도에 따른 색상
  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }

  /// 신호 강도에 따른 아이콘
  IconData _getSignalIcon(int rssi) {
    if (rssi >= -50) return Icons.signal_cellular_4_bar;
    if (rssi >= -70) return Icons.signal_cellular_alt;
    return Icons.signal_cellular_alt_1_bar;
  }

  /// 신호 강도 텍스트
  String _getSignalText(int rssi) {
    if (rssi >= -50) return '신호 강함';
    if (rssi >= -70) return '신호 보통';
    return '신호 약함';
  }
}
