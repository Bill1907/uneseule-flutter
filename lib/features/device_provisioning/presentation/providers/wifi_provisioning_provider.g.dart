// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_provisioning_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wifiStatusStreamHash() => r'f50ca9c0b1fb6885a1b29df16fe8110826e9146d';

/// WiFi 상태 스트림 Provider
///
/// Copied from [wifiStatusStream].
@ProviderFor(wifiStatusStream)
final wifiStatusStreamProvider = AutoDisposeStreamProvider<WifiStatus>.internal(
  wifiStatusStream,
  name: r'wifiStatusStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wifiStatusStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WifiStatusStreamRef = AutoDisposeStreamProviderRef<WifiStatus>;
String _$wifiProvisioningHash() => r'0d0a1d53810aba084b62ba68f3b486524e9ccefd';

/// WiFi Provisioning 상태 관리 Provider
///
/// Copied from [WifiProvisioning].
@ProviderFor(WifiProvisioning)
final wifiProvisioningProvider = AutoDisposeNotifierProvider<
  WifiProvisioning,
  AsyncValue<WifiStatus>
>.internal(
  WifiProvisioning.new,
  name: r'wifiProvisioningProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wifiProvisioningHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WifiProvisioning = AutoDisposeNotifier<AsyncValue<WifiStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
