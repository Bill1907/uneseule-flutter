import '../entities/wifi_status.dart';
import '../repositories/device_repository.dart';
import '../../../../core/constants/ble_constants.dart';

/// WiFi Provisioning UseCase
class ProvisionWifiUseCase {
  final DeviceRepository _repository;

  ProvisionWifiUseCase(this._repository);

  /// WiFi Provisioning 시작
  /// [credentials] SSID와 비밀번호
  Future<void> call(WifiCredentials credentials) async {
    // 1. WiFi 인증 정보 전송
    await _repository.sendWifiCredentials(credentials);

    // 2. Provisioning 시작 명령 전송
    await _repository.sendProvisioningCommand(BleConstants.cmdStartProvisioning);
  }

  /// WiFi 상태 스트림
  Stream<WifiStatus> get statusStream => _repository.wifiStatusStream;

  /// Provisioning 취소
  Future<void> cancel() =>
      _repository.sendProvisioningCommand(BleConstants.cmdStopProvisioning);
}
