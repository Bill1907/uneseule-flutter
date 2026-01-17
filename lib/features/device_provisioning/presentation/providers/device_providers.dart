import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/ble_datasource.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/scan_devices.dart';
import '../../domain/usecases/connect_device.dart';
import '../../domain/usecases/read_device_info.dart';
import '../../domain/usecases/provision_wifi.dart';

part 'device_providers.g.dart';

// === Data Source ===

/// BLE DataSource Provider
@riverpod
BleDataSource bleDataSource(Ref ref) {
  final dataSource = BleDataSource();
  ref.onDispose(() => dataSource.dispose());
  return dataSource;
}

// === Repository ===

/// Device Repository Provider
@riverpod
DeviceRepository deviceRepository(Ref ref) {
  return DeviceRepositoryImpl(ref.watch(bleDataSourceProvider));
}

// === Use Cases ===

/// 디바이스 스캔 UseCase Provider
@riverpod
ScanDevicesUseCase scanDevicesUseCase(Ref ref) {
  return ScanDevicesUseCase(ref.watch(deviceRepositoryProvider));
}

/// 디바이스 연결 UseCase Provider
@riverpod
ConnectDeviceUseCase connectDeviceUseCase(Ref ref) {
  return ConnectDeviceUseCase(ref.watch(deviceRepositoryProvider));
}

/// 디바이스 정보 읽기 UseCase Provider
@riverpod
ReadDeviceInfoUseCase readDeviceInfoUseCase(Ref ref) {
  return ReadDeviceInfoUseCase(ref.watch(deviceRepositoryProvider));
}

/// WiFi Provisioning UseCase Provider
@riverpod
ProvisionWifiUseCase provisionWifiUseCase(Ref ref) {
  return ProvisionWifiUseCase(ref.watch(deviceRepositoryProvider));
}
