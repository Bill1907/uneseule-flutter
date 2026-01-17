import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/device_provisioning/presentation/screens/device_scan_screen.dart';
import '../../features/device_provisioning/presentation/screens/device_connect_screen.dart';
import '../../features/device_provisioning/presentation/screens/wifi_setup_screen.dart';
import '../../features/device_provisioning/presentation/screens/provisioning_complete_screen.dart';

/// 앱 라우터 Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // 홈 화면 (임시 - 디바이스 스캔으로 리다이렉트)
      GoRoute(
        path: '/',
        redirect: (context, state) => '/device-provisioning',
      ),

      // Device Provisioning Flow
      GoRoute(
        path: '/device-provisioning',
        builder: (context, state) => const DeviceScanScreen(),
        routes: [
          // 디바이스 연결 화면
          GoRoute(
            path: 'connect/:deviceId',
            builder: (context, state) {
              final deviceId = state.pathParameters['deviceId']!;
              return DeviceConnectScreen(deviceId: deviceId);
            },
          ),
          // WiFi 설정 화면
          GoRoute(
            path: 'wifi-setup',
            builder: (context, state) => const WifiSetupScreen(),
          ),
          // 설정 완료 화면
          GoRoute(
            path: 'complete',
            builder: (context, state) => const ProvisioningCompleteScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('페이지를 찾을 수 없습니다: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
});
