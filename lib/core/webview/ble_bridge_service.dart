import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/device_provisioning/data/datasources/ble_datasource.dart';
import '../../features/device_provisioning/data/models/wifi_credentials_model.dart';
import 'bridge_errors.dart';
import 'bridge_message.dart';

/// BLE 기능을 JavaScript Bridge로 노출하는 서비스
class BleBridgeService {
  final BleDataSource _bleDataSource;
  final void Function(BridgeEvent) _sendEvent;

  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _batterySubscription;
  StreamSubscription? _wifiStatusSubscription;

  BleBridgeService(this._bleDataSource, this._sendEvent) {
    _setupStreams();
  }

  /// 스트림 리스너 설정
  void _setupStreams() {
    // 연결 상태 변경 이벤트
    _connectionSubscription =
        _bleDataSource.connectionStateStream.listen((connected) {
      _sendEvent(BridgeEvent(
        type: 'connectionStateChanged',
        payload: {'connected': connected},
      ));
    });

    // 배터리 레벨 이벤트
    _batterySubscription = _bleDataSource.batteryLevelStream.listen((level) {
      _sendEvent(BridgeEvent(
        type: 'batteryLevelChanged',
        payload: {'level': level},
      ));
    });

    // WiFi 상태 이벤트
    _wifiStatusSubscription =
        _bleDataSource.wifiStatusStream.listen((statusModel) {
      final status = statusModel.toEntity();
      _sendEvent(BridgeEvent(
        type: 'wifiStatusChanged',
        payload: {
          'state': status.state.name,
          'ssid': status.ssid,
          'ipAddress': status.ipAddress,
          'errorMessage': status.errorMessage,
        },
      ));
    });
  }

  // === BLE API Methods ===

  /// Bluetooth 활성화 상태 확인
  Future<Map<String, dynamic>> isBluetoothEnabled() async {
    final enabled = await _bleDataSource.isBluetoothEnabled();
    return {'enabled': enabled};
  }

  /// 디바이스 스캔 시작
  Future<void> scanDevices() async {
    await _scanSubscription?.cancel();

    try {
      _scanSubscription = _bleDataSource.scanDevices().listen(
        (devices) {
          _sendEvent(BridgeEvent(
            type: 'scanResult',
            payload: {
              'devices': devices
                  .map((d) => {
                        'id': d.id,
                        'name': d.name,
                        'rssi': d.rssi,
                        'isConnectable': d.isConnectable,
                      })
                  .toList(),
            },
          ));
        },
        onError: (error) {
          debugPrint('[BleBridgeService] Scan error: $error');
          _sendEvent(BridgeEvent(
            type: 'scanError',
            payload: {'error': error.toString()},
          ));
        },
        onDone: () {
          _sendEvent(BridgeEvent(
            type: 'scanComplete',
            payload: {},
          ));
        },
      );
    } catch (e) {
      throw BleScanFailedException(e.toString());
    }
  }

  /// 스캔 중지
  Future<void> stopScan() async {
    await _bleDataSource.stopScan();
    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  /// 디바이스 연결
  Future<Map<String, dynamic>> connectDevice(String deviceId) async {
    try {
      await _bleDataSource.connect(deviceId);
      return {'connected': true};
    } catch (e) {
      throw BleConnectionFailedException(deviceId, e.toString());
    }
  }

  /// 디바이스 연결 해제
  Future<void> disconnectDevice() async {
    await _bleDataSource.disconnect();
  }

  /// 디바이스 정보 읽기
  Future<Map<String, dynamic>> readDeviceInfo() async {
    try {
      final info = await _bleDataSource.readDeviceInfo();
      return {
        'id': info.id,
        'name': info.name,
        'macAddress': info.macAddress,
        'firmwareVersion': info.firmwareVersion,
        'batteryLevel': info.batteryLevel,
        'secretKey': info.secretKey,
        'rssi': info.rssi,
      };
    } catch (e) {
      if (e.toString().contains('연결되지 않았습니다')) {
        throw BleNotConnectedException();
      }
      rethrow;
    }
  }

  /// WiFi Credentials 전송
  Future<void> sendWifiCredentials(String ssid, String password) async {
    try {
      final credentials = WifiCredentialsModel(ssid: ssid, password: password);
      await _bleDataSource.sendWifiCredentials(credentials);
    } catch (e) {
      if (e.toString().contains('연결되지 않았습니다')) {
        throw BleNotConnectedException();
      }
      throw WifiProvisioningFailedException(e.toString());
    }
  }

  /// Provisioning 명령 전송
  Future<void> sendProvisioningCommand(int command) async {
    try {
      await _bleDataSource.sendProvisioningCommand(command);
    } catch (e) {
      if (e.toString().contains('연결되지 않았습니다')) {
        throw BleNotConnectedException();
      }
      rethrow;
    }
  }

  /// 리소스 해제
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _batterySubscription?.cancel();
    _wifiStatusSubscription?.cancel();
  }
}
