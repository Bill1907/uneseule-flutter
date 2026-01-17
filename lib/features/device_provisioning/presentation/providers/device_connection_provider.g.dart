// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectionStatusHash() => r'daea0ebaa6e2068334c252d0d7ed29f88251d2b9';

/// 연결 상태 스트림 Provider
///
/// Copied from [connectionStatus].
@ProviderFor(connectionStatus)
final connectionStatusProvider = AutoDisposeStreamProvider<bool>.internal(
  connectionStatus,
  name: r'connectionStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectionStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectionStatusRef = AutoDisposeStreamProviderRef<bool>;
String _$batteryLevelHash() => r'b165f500d2c4df137cb240db1b79500d87b04ce9';

/// 배터리 레벨 스트림 Provider
///
/// Copied from [batteryLevel].
@ProviderFor(batteryLevel)
final batteryLevelProvider = AutoDisposeStreamProvider<int>.internal(
  batteryLevel,
  name: r'batteryLevelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$batteryLevelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BatteryLevelRef = AutoDisposeStreamProviderRef<int>;
String _$deviceConnectionHash() => r'a8daef7b817c03a1e550c7425105c8958d67b648';

/// 디바이스 연결 상태 관리 Provider
///
/// Copied from [DeviceConnection].
@ProviderFor(DeviceConnection)
final deviceConnectionProvider = AutoDisposeNotifierProvider<
  DeviceConnection,
  DeviceConnectionState
>.internal(
  DeviceConnection.new,
  name: r'deviceConnectionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deviceConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeviceConnection = AutoDisposeNotifier<DeviceConnectionState>;
String _$connectedDeviceInfoHash() =>
    r'72d349b965a98b338a120fa57accc2b8919c4ec4';

/// 연결된 디바이스 정보 관리 Provider
///
/// Copied from [ConnectedDeviceInfo].
@ProviderFor(ConnectedDeviceInfo)
final connectedDeviceInfoProvider = AutoDisposeNotifierProvider<
  ConnectedDeviceInfo,
  AsyncValue<DeviceInfo?>
>.internal(
  ConnectedDeviceInfo.new,
  name: r'connectedDeviceInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectedDeviceInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectedDeviceInfo = AutoDisposeNotifier<AsyncValue<DeviceInfo?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
