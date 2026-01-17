import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../core/constants/ble_constants.dart';
import '../../domain/entities/device_info.dart';
import '../models/device_info_model.dart';
import '../models/wifi_credentials_model.dart';

/// BLE 통신 DataSource
/// flutter_blue_plus를 사용하여 ESP32-S3 디바이스와 통신
class BleDataSource {
  BluetoothDevice? _connectedDevice;
  List<BluetoothService>? _services;
  bool _isConnecting = false;

  StreamSubscription? _connectionSubscription;
  StreamSubscription? _batterySubscription;
  StreamSubscription? _wifiStatusSubscription;

  final _connectionStateController = StreamController<bool>.broadcast();
  final _batteryLevelController = StreamController<int>.broadcast();
  final _wifiStatusController = StreamController<WifiStatusModel>.broadcast();

  /// 연결 상태 스트림
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  /// 배터리 레벨 스트림
  Stream<int> get batteryLevelStream => _batteryLevelController.stream;

  /// WiFi 상태 스트림
  Stream<WifiStatusModel> get wifiStatusStream => _wifiStatusController.stream;

  /// 연결된 디바이스 존재 여부
  bool get isConnected => _connectedDevice != null;

  /// 연결된 디바이스 ID (null이면 연결 안됨)
  String? get connectedDeviceId => _connectedDevice?.remoteId.str;

  /// BLE 어댑터 상태 확인
  Future<bool> isBluetoothEnabled() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  /// 디바이스 스캔
  Stream<List<ScannedDevice>> scanDevices() async* {
    // Bluetooth 활성화 대기
    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      throw Exception('Bluetooth가 비활성화되어 있습니다');
    }

    final scannedDevices = <String, ScannedDevice>{};

    // 스캔 결과 구독
    final subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (final result in results) {
        final name = result.advertisementData.advName;
        if (name.startsWith(BleConstants.deviceNamePrefix)) {
          scannedDevices[result.device.remoteId.str] = ScannedDevice(
            id: result.device.remoteId.str,
            name: name,
            rssi: result.rssi,
            isConnectable: result.advertisementData.connectable,
          );
        }
      }
    });

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // 스캔 시작
    await FlutterBluePlus.startScan(
      timeout: BleConstants.scanTimeout,
      androidUsesFineLocation: true,
    );

    // 주기적으로 결과 전달
    while (FlutterBluePlus.isScanningNow) {
      yield scannedDevices.values.toList()
        ..sort((a, b) => b.rssi.compareTo(a.rssi)); // 신호 강도순 정렬
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // 최종 결과
    yield scannedDevices.values.toList()
      ..sort((a, b) => b.rssi.compareTo(a.rssi));
  }

  /// 스캔 중지
  Future<void> stopScan() async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
  }

  /// 디바이스 연결
  Future<void> connect(String deviceId) async {
    // 이미 연결 중인 경우 방지
    if (_isConnecting) {
      throw Exception('이미 연결 진행 중입니다');
    }

    // 이미 연결된 경우 방지
    if (_connectedDevice != null) {
      if (_connectedDevice!.remoteId.str == deviceId) {
        // 같은 디바이스에 이미 연결됨
        return;
      }
      throw Exception('다른 디바이스에 이미 연결되어 있습니다. 먼저 연결을 해제해주세요.');
    }

    _isConnecting = true;

    try {
      final device = BluetoothDevice.fromId(deviceId);

      // 연결 상태 모니터링
      _connectionSubscription = device.connectionState.listen((state) {
      final isConnected = state == BluetoothConnectionState.connected;
      _connectionStateController.add(isConnected);

      if (!isConnected) {
        _cleanupConnection();
      }
    });

      // 연결
      await device.connect(
        timeout: BleConstants.connectionTimeout,
        mtu: null, // 자동 MTU 협상
      );

      _connectedDevice = device;

      // MTU 요청 (Android)
      try {
        await device.requestMtu(512);
      } catch (e) {
        debugPrint('[BLE] MTU 요청 실패: $e');
      }

      // 서비스 검색
      _services = await device.discoverServices();

      // 안정화 대기
      await Future.delayed(BleConstants.serviceDiscoveryDelay);

      // Notification 설정
      await _setupNotifications();
    } finally {
      _isConnecting = false;
    }
  }

  /// Notification 설정
  Future<void> _setupNotifications() async {
    if (_services == null) return;

    // Battery Level Notification
    final batteryChar = _findCharacteristic(
      BleConstants.batteryServiceUuid,
      BleConstants.batteryLevelCharUuid,
    );
    if (batteryChar != null && batteryChar.properties.notify) {
      _batterySubscription = batteryChar.onValueReceived.listen((value) {
        if (value.isNotEmpty) {
          _batteryLevelController.add(value[0]);
        }
      });
      await batteryChar.setNotifyValue(true);
    }

    // WiFi Status Notification
    final wifiStatusChar = _findCharacteristic(
      BleConstants.wifiProvServiceUuid,
      BleConstants.wifiStatusCharUuid,
    );
    if (wifiStatusChar != null && wifiStatusChar.properties.notify) {
      _wifiStatusSubscription = wifiStatusChar.onValueReceived.listen((value) {
        _wifiStatusController.add(WifiStatusModel.fromBytes(value));
      });
      await wifiStatusChar.setNotifyValue(true);
    }
  }

  /// 연결 정리
  void _cleanupConnection() {
    _connectedDevice = null;
    _services = null;
  }

  /// 연결 해제
  Future<void> disconnect() async {
    await _batterySubscription?.cancel();
    await _wifiStatusSubscription?.cancel();
    await _connectionSubscription?.cancel();

    _batterySubscription = null;
    _wifiStatusSubscription = null;
    _connectionSubscription = null;

    await _connectedDevice?.disconnect();
    _cleanupConnection();
  }

  /// 디바이스 정보 읽기
  Future<DeviceInfoModel> readDeviceInfo() async {
    if (_connectedDevice == null || _services == null) {
      throw Exception('디바이스에 연결되지 않았습니다');
    }

    // MAC Address 읽기
    List<int> macAddressBytes = [];
    try {
      final macAddressChar = _findCharacteristic(
        BleConstants.deviceInfoServiceUuid,
        BleConstants.manufacturerNameCharUuid,
      );
      macAddressBytes = await macAddressChar?.read() ?? [];
    } catch (e) {
      debugPrint('[BLE] MAC Address 읽기 실패: $e');
    }

    // Firmware Version 읽기
    List<int> firmwareBytes = [];
    try {
      final firmwareChar = _findCharacteristic(
        BleConstants.deviceInfoServiceUuid,
        BleConstants.firmwareRevisionCharUuid,
      );
      firmwareBytes = await firmwareChar?.read() ?? [];
    } catch (e) {
      debugPrint('[BLE] Firmware Version 읽기 실패: $e');
    }

    // Battery Level 읽기
    int batteryLevel = 0;
    try {
      final batteryChar = _findCharacteristic(
        BleConstants.batteryServiceUuid,
        BleConstants.batteryLevelCharUuid,
      );
      final batteryBytes = await batteryChar?.read() ?? [];
      batteryLevel = batteryBytes.isNotEmpty ? batteryBytes[0] : 0;
    } catch (e) {
      debugPrint('[BLE] Battery Level 읽기 실패: $e');
    }

    // Secret Key 읽기
    List<int>? secretKeyBytes;
    try {
      final secretKeyChar = _findCharacteristic(
        BleConstants.wifiProvServiceUuid,
        BleConstants.deviceSecretKeyCharUuid,
      );
      secretKeyBytes = await secretKeyChar?.read();
    } catch (e) {
      debugPrint('[BLE] Secret Key 읽기 실패: $e');
    }

    // RSSI 읽기
    int rssi = -100;
    try {
      rssi = await _connectedDevice!.readRssi();
    } catch (e) {
      debugPrint('[BLE] RSSI 읽기 실패: $e');
    }

    return DeviceInfoModel.fromBleData(
      id: _connectedDevice!.remoteId.str,
      name: _connectedDevice!.platformName,
      macAddressBytes: macAddressBytes,
      firmwareBytes: firmwareBytes,
      batteryLevel: batteryLevel,
      secretKeyBytes: secretKeyBytes,
      rssi: rssi,
    );
  }

  /// WiFi Credentials 전송
  Future<void> sendWifiCredentials(WifiCredentialsModel credentials) async {
    if (_services == null) {
      throw Exception('디바이스에 연결되지 않았습니다');
    }

    // SSID 전송
    final ssidChar = _findCharacteristic(
      BleConstants.wifiProvServiceUuid,
      BleConstants.wifiSsidCharUuid,
    );
    if (ssidChar == null) {
      throw Exception('SSID characteristic을 찾을 수 없습니다');
    }
    await ssidChar.write(credentials.ssidBytes, withoutResponse: false);

    // Password 전송
    final passwordChar = _findCharacteristic(
      BleConstants.wifiProvServiceUuid,
      BleConstants.wifiPasswordCharUuid,
    );
    if (passwordChar == null) {
      throw Exception('Password characteristic을 찾을 수 없습니다');
    }
    await passwordChar.write(credentials.passwordBytes, withoutResponse: false);
  }

  /// Provisioning 명령 전송
  Future<void> sendProvisioningCommand(int command) async {
    if (_services == null) {
      throw Exception('디바이스에 연결되지 않았습니다');
    }

    final commandChar = _findCharacteristic(
      BleConstants.wifiProvServiceUuid,
      BleConstants.provisioningCommandCharUuid,
    );
    if (commandChar == null) {
      throw Exception('Command characteristic을 찾을 수 없습니다');
    }
    await commandChar.write([command], withoutResponse: false);
  }

  /// Characteristic 찾기
  BluetoothCharacteristic? _findCharacteristic(
    String serviceUuid,
    String characteristicUuid,
  ) {
    if (_services == null) return null;

    final normalizedServiceUuid = serviceUuid.toLowerCase();
    final normalizedCharUuid = characteristicUuid.toLowerCase();

    for (final service in _services!) {
      final serviceUuidStr = service.uuid.str.toLowerCase();
      // 표준 16bit UUID 또는 전체 128bit UUID 매칭
      if (serviceUuidStr.contains(normalizedServiceUuid) ||
          normalizedServiceUuid.contains(serviceUuidStr)) {
        for (final char in service.characteristics) {
          final charUuidStr = char.uuid.str.toLowerCase();
          if (charUuidStr.contains(normalizedCharUuid) ||
              normalizedCharUuid.contains(charUuidStr)) {
            return char;
          }
        }
      }
    }

    return null;
  }

  /// 리소스 해제
  void dispose() {
    _batterySubscription?.cancel();
    _wifiStatusSubscription?.cancel();
    _connectionSubscription?.cancel();
    _connectionStateController.close();
    _batteryLevelController.close();
    _wifiStatusController.close();
  }
}
