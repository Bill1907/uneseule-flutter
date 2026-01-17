import '../entities/device_info.dart';
import '../repositories/device_repository.dart';

/// 디바이스 정보 읽기 UseCase
class ReadDeviceInfoUseCase {
  final DeviceRepository _repository;

  ReadDeviceInfoUseCase(this._repository);

  /// 디바이스 정보 읽기
  Future<DeviceInfo> call() => _repository.readDeviceInfo();

  /// 배터리 레벨 스트림
  Stream<int> get batteryLevel => _repository.batteryLevelStream;

  /// 현재 연결된 디바이스 정보
  DeviceInfo? get currentDevice => _repository.currentDevice;
}
