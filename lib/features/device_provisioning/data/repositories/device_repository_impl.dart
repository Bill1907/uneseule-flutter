import '../../domain/entities/device_info.dart';
import '../../domain/entities/wifi_status.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/ble_datasource.dart';
import '../models/wifi_credentials_model.dart';

/// DeviceRepository 구현체
class DeviceRepositoryImpl implements DeviceRepository {
  final BleDataSource _dataSource;
  DeviceInfo? _currentDevice;

  DeviceRepositoryImpl(this._dataSource);

  @override
  Stream<List<ScannedDevice>> scanDevices() => _dataSource.scanDevices();

  @override
  Future<void> stopScan() => _dataSource.stopScan();

  @override
  Future<void> connectDevice(String deviceId) => _dataSource.connect(deviceId);

  @override
  Future<void> disconnectDevice() async {
    await _dataSource.disconnect();
    _currentDevice = null;
  }

  @override
  Stream<bool> get connectionStateStream => _dataSource.connectionStateStream;

  @override
  Future<DeviceInfo> readDeviceInfo() async {
    final model = await _dataSource.readDeviceInfo();
    _currentDevice = model.toEntity();
    return _currentDevice!;
  }

  @override
  Stream<int> get batteryLevelStream => _dataSource.batteryLevelStream;

  @override
  Future<void> sendWifiCredentials(WifiCredentials credentials) {
    final model = WifiCredentialsModel.fromEntity(credentials);
    return _dataSource.sendWifiCredentials(model);
  }

  @override
  Stream<WifiStatus> get wifiStatusStream =>
      _dataSource.wifiStatusStream.map((model) => model.toEntity());

  @override
  Future<void> sendProvisioningCommand(int command) =>
      _dataSource.sendProvisioningCommand(command);

  @override
  DeviceInfo? get currentDevice => _currentDevice;
}
