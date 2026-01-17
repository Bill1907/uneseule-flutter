import '../repositories/device_repository.dart';

/// 디바이스 연결 UseCase
class ConnectDeviceUseCase {
  final DeviceRepository _repository;

  ConnectDeviceUseCase(this._repository);

  /// 디바이스 연결
  /// [deviceId] BLE remoteId
  Future<void> call(String deviceId) => _repository.connectDevice(deviceId);

  /// 디바이스 연결 해제
  Future<void> disconnect() => _repository.disconnectDevice();

  /// 연결 상태 스트림
  Stream<bool> get connectionState => _repository.connectionStateStream;
}
