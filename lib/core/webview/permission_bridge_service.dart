import 'dart:io';

import 'package:permission_handler/permission_handler.dart' as ph;

/// 권한 관리 Bridge 서비스
class PermissionBridgeService {
  /// BLE 권한 상태 확인
  Future<Map<String, dynamic>> checkBlePermissions() async {
    final permissions = <String, String>{};

    if (Platform.isAndroid) {
      permissions['bluetoothScan'] =
          (await ph.Permission.bluetoothScan.status).name;
      permissions['bluetoothConnect'] =
          (await ph.Permission.bluetoothConnect.status).name;
      permissions['location'] =
          (await ph.Permission.locationWhenInUse.status).name;
    } else if (Platform.isIOS) {
      permissions['bluetooth'] = (await ph.Permission.bluetooth.status).name;
    }

    return {
      'granted': _isAllGranted(permissions),
      'permissions': permissions,
    };
  }

  /// BLE 권한 요청
  Future<Map<String, dynamic>> requestBlePermissions() async {
    final results = <String, String>{};

    if (Platform.isAndroid) {
      final statuses = await [
        ph.Permission.bluetoothScan,
        ph.Permission.bluetoothConnect,
        ph.Permission.locationWhenInUse,
      ].request();

      for (final entry in statuses.entries) {
        final permName = _getPermissionName(entry.key);
        results[permName] = entry.value.name;
      }
    } else if (Platform.isIOS) {
      final status = await ph.Permission.bluetooth.request();
      results['bluetooth'] = status.name;
    }

    return {
      'granted': _isAllGranted(results),
      'permissions': results,
    };
  }

  /// 설정 앱 열기 (권한 영구 거부 시)
  Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }

  /// 모든 권한이 부여되었는지 확인
  bool _isAllGranted(Map<String, String> permissions) {
    return permissions.values.every(
      (status) => status == 'granted' || status == 'limited',
    );
  }

  /// Permission enum에서 이름 추출
  String _getPermissionName(ph.Permission permission) {
    final str = permission.toString();
    // "Permission.bluetoothScan" -> "bluetoothScan"
    return str.substring(str.indexOf('.') + 1);
  }
}
