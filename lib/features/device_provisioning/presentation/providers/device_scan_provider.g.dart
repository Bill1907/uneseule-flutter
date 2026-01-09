// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deviceScanHash() => r'b817a8cf5b848fcafa170f6ae94fa9ebba371d13';

/// 디바이스 스캔 상태 관리 Provider
///
/// Copied from [DeviceScan].
@ProviderFor(DeviceScan)
final deviceScanProvider = AutoDisposeNotifierProvider<
  DeviceScan,
  AsyncValue<List<ScannedDevice>>
>.internal(
  DeviceScan.new,
  name: r'deviceScanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deviceScanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeviceScan = AutoDisposeNotifier<AsyncValue<List<ScannedDevice>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
