import '../entities/device_info.dart';
import '../repositories/device_repository.dart';

/// 디바이스 스캔 UseCase
class ScanDevicesUseCase {
  final DeviceRepository _repository;

  ScanDevicesUseCase(this._repository);

  /// 스캔 시작 및 결과 스트림 반환
  Stream<List<ScannedDevice>> call() => _repository.scanDevices();

  /// 스캔 중지
  Future<void> stop() => _repository.stopScan();
}
