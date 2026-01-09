import '../entities/device_info.dart';
import '../entities/wifi_status.dart';

/// 디바이스 Repository 인터페이스
abstract class DeviceRepository {
  /// BLE 디바이스 스캔 시작
  /// [ScannedDevice] 리스트를 주기적으로 반환
  Stream<List<ScannedDevice>> scanDevices();

  /// 스캔 중지
  Future<void> stopScan();

  /// 디바이스 연결
  /// [deviceId] BLE remoteId
  Future<void> connectDevice(String deviceId);

  /// 디바이스 연결 해제
  Future<void> disconnectDevice();

  /// 연결 상태 스트림
  /// true: 연결됨, false: 연결 해제됨
  Stream<bool> get connectionStateStream;

  /// 디바이스 정보 읽기
  /// BLE GATT Characteristics에서 디바이스 정보를 읽어옴
  Future<DeviceInfo> readDeviceInfo();

  /// 배터리 레벨 스트림 (Notify)
  /// 실시간 배터리 잔량 업데이트
  Stream<int> get batteryLevelStream;

  /// WiFi credentials 전송
  /// [credentials] SSID와 비밀번호
  Future<void> sendWifiCredentials(WifiCredentials credentials);

  /// WiFi 상태 스트림 (Notify)
  /// Provisioning 진행 상태를 실시간으로 반환
  Stream<WifiStatus> get wifiStatusStream;

  /// Provisioning 명령 전송
  /// [command] BleConstants에 정의된 명령 코드
  Future<void> sendProvisioningCommand(int command);

  /// 현재 연결된 디바이스 정보
  DeviceInfo? get currentDevice;
}
