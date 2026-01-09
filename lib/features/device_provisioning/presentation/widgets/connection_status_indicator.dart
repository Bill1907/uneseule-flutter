import 'package:flutter/material.dart';

import '../../domain/entities/wifi_status.dart';

/// WiFi 연결 상태 표시 위젯
class ConnectionStatusIndicator extends StatelessWidget {
  final WifiStatus status;

  const ConnectionStatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 상태 아이콘
        _buildIcon(theme),
        const SizedBox(height: 16),

        // 상태 텍스트
        Text(
          _getStatusText(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        // 에러 메시지
        if (status.errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            status.errorMessage!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // 연결 정보
        if (status.state == WifiConnectionState.connected) ...[
          const SizedBox(height: 16),
          if (status.ssid != null)
            _buildInfoRow(context, 'WiFi', status.ssid!),
          if (status.ipAddress != null)
            _buildInfoRow(context, 'IP', status.ipAddress!),
        ],
      ],
    );
  }

  Widget _buildIcon(ThemeData theme) {
    switch (status.state) {
      case WifiConnectionState.disconnected:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.wifi_off,
            size: 64,
            color: Colors.grey,
          ),
        );

      case WifiConnectionState.connecting:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        );

      case WifiConnectionState.connected:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.wifi,
            size: 64,
            color: Colors.green,
          ),
        );

      case WifiConnectionState.failed:
      case WifiConnectionState.wrongPassword:
      case WifiConnectionState.noAccessPoint:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.wifi_off,
            size: 64,
            color: Colors.red,
          ),
        );
    }
  }

  String _getStatusText() {
    switch (status.state) {
      case WifiConnectionState.disconnected:
        return 'WiFi에 연결되지 않음';
      case WifiConnectionState.connecting:
        return 'WiFi 연결 중...';
      case WifiConnectionState.connected:
        return 'WiFi 연결 완료!';
      case WifiConnectionState.failed:
        return '연결 실패';
      case WifiConnectionState.wrongPassword:
        return '비밀번호 오류';
      case WifiConnectionState.noAccessPoint:
        return '네트워크를 찾을 수 없음';
    }
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
