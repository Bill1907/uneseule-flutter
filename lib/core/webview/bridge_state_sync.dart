import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../features/device_provisioning/data/datasources/ble_datasource.dart';
import 'bridge_message.dart';
import 'permission_bridge_service.dart';

/// Bridge 초기 상태 동기화 서비스
class BridgeStateSync {
  final BleDataSource _bleDataSource;
  final PermissionBridgeService _permissionService;
  final Future<void> Function(BridgeEvent) _sendEvent;

  BridgeStateSync(
    this._bleDataSource,
    this._permissionService,
    this._sendEvent,
  );

  /// WebView 로드 완료 시 호출 - 현재 상태 전송
  Future<void> syncInitialState() async {
    try {
      final state = await _collectCurrentState();
      await _sendEvent(BridgeEvent(
        type: 'initialState',
        payload: state,
      ));
      debugPrint('[BridgeStateSync] Initial state synced: $state');
    } catch (e, st) {
      debugPrint('[BridgeStateSync] Failed to sync initial state: $e\n$st');
    }
  }

  /// 현재 상태 수집
  Future<Map<String, dynamic>> _collectCurrentState() async {
    // Bluetooth 상태
    bool bluetoothEnabled = false;
    try {
      bluetoothEnabled = await _bleDataSource.isBluetoothEnabled();
    } catch (e) {
      debugPrint('[BridgeStateSync] Failed to check bluetooth: $e');
    }

    // 권한 상태
    Map<String, dynamic> permissionStatus = {};
    try {
      permissionStatus = await _permissionService.checkBlePermissions();
    } catch (e) {
      debugPrint('[BridgeStateSync] Failed to check permissions: $e');
    }

    // 연결된 디바이스 정보
    Map<String, dynamic>? connectedDevice;
    if (_bleDataSource.isConnected) {
      try {
        final info = await _bleDataSource.readDeviceInfo();
        connectedDevice = {
          'id': info.id,
          'name': info.name,
          'batteryLevel': info.batteryLevel,
          'firmwareVersion': info.firmwareVersion,
        };
      } catch (e) {
        debugPrint('[BridgeStateSync] Failed to read device info: $e');
        // 연결은 되어 있지만 정보를 읽지 못한 경우
        connectedDevice = {
          'id': _bleDataSource.connectedDeviceId,
        };
      }
    }

    return {
      'bluetooth': {
        'enabled': bluetoothEnabled,
        'connected': _bleDataSource.isConnected,
        'device': connectedDevice,
      },
      'permissions': permissionStatus,
      'platform': Platform.isIOS ? 'ios' : 'android',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
