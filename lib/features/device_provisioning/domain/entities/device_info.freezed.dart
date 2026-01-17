// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeviceInfo {
  /// BLE remoteId
  String get id => throw _privateConstructorUsedError;

  /// 디바이스 이름 (예: Uneseule-001)
  String get name => throw _privateConstructorUsedError;

  /// MAC 주소
  String get macAddress => throw _privateConstructorUsedError;

  /// 펌웨어 버전
  String get firmwareVersion => throw _privateConstructorUsedError;

  /// 배터리 잔량 (0-100%)
  int get batteryLevel => throw _privateConstructorUsedError;

  /// 디바이스 고유 인증키
  String? get secretKey => throw _privateConstructorUsedError;

  /// BLE 신호 강도 (RSSI)
  int get rssi => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoCopyWith<DeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
    DeviceInfo value,
    $Res Function(DeviceInfo) then,
  ) = _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
  @useResult
  $Res call({
    String id,
    String name,
    String macAddress,
    String firmwareVersion,
    int batteryLevel,
    String? secretKey,
    int rssi,
  });
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? macAddress = null,
    Object? firmwareVersion = null,
    Object? batteryLevel = null,
    Object? secretKey = freezed,
    Object? rssi = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            macAddress:
                null == macAddress
                    ? _value.macAddress
                    : macAddress // ignore: cast_nullable_to_non_nullable
                        as String,
            firmwareVersion:
                null == firmwareVersion
                    ? _value.firmwareVersion
                    : firmwareVersion // ignore: cast_nullable_to_non_nullable
                        as String,
            batteryLevel:
                null == batteryLevel
                    ? _value.batteryLevel
                    : batteryLevel // ignore: cast_nullable_to_non_nullable
                        as int,
            secretKey:
                freezed == secretKey
                    ? _value.secretKey
                    : secretKey // ignore: cast_nullable_to_non_nullable
                        as String?,
            rssi:
                null == rssi
                    ? _value.rssi
                    : rssi // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceInfoImplCopyWith<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  factory _$$DeviceInfoImplCopyWith(
    _$DeviceInfoImpl value,
    $Res Function(_$DeviceInfoImpl) then,
  ) = __$$DeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String macAddress,
    String firmwareVersion,
    int batteryLevel,
    String? secretKey,
    int rssi,
  });
}

/// @nodoc
class __$$DeviceInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$DeviceInfoImpl>
    implements _$$DeviceInfoImplCopyWith<$Res> {
  __$$DeviceInfoImplCopyWithImpl(
    _$DeviceInfoImpl _value,
    $Res Function(_$DeviceInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? macAddress = null,
    Object? firmwareVersion = null,
    Object? batteryLevel = null,
    Object? secretKey = freezed,
    Object? rssi = null,
  }) {
    return _then(
      _$DeviceInfoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        macAddress:
            null == macAddress
                ? _value.macAddress
                : macAddress // ignore: cast_nullable_to_non_nullable
                    as String,
        firmwareVersion:
            null == firmwareVersion
                ? _value.firmwareVersion
                : firmwareVersion // ignore: cast_nullable_to_non_nullable
                    as String,
        batteryLevel:
            null == batteryLevel
                ? _value.batteryLevel
                : batteryLevel // ignore: cast_nullable_to_non_nullable
                    as int,
        secretKey:
            freezed == secretKey
                ? _value.secretKey
                : secretKey // ignore: cast_nullable_to_non_nullable
                    as String?,
        rssi:
            null == rssi
                ? _value.rssi
                : rssi // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$DeviceInfoImpl implements _DeviceInfo {
  const _$DeviceInfoImpl({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.firmwareVersion,
    required this.batteryLevel,
    this.secretKey,
    required this.rssi,
  });

  /// BLE remoteId
  @override
  final String id;

  /// 디바이스 이름 (예: Uneseule-001)
  @override
  final String name;

  /// MAC 주소
  @override
  final String macAddress;

  /// 펌웨어 버전
  @override
  final String firmwareVersion;

  /// 배터리 잔량 (0-100%)
  @override
  final int batteryLevel;

  /// 디바이스 고유 인증키
  @override
  final String? secretKey;

  /// BLE 신호 강도 (RSSI)
  @override
  final int rssi;

  @override
  String toString() {
    return 'DeviceInfo(id: $id, name: $name, macAddress: $macAddress, firmwareVersion: $firmwareVersion, batteryLevel: $batteryLevel, secretKey: $secretKey, rssi: $rssi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.firmwareVersion, firmwareVersion) ||
                other.firmwareVersion == firmwareVersion) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.secretKey, secretKey) ||
                other.secretKey == secretKey) &&
            (identical(other.rssi, rssi) || other.rssi == rssi));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    macAddress,
    firmwareVersion,
    batteryLevel,
    secretKey,
    rssi,
  );

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      __$$DeviceInfoImplCopyWithImpl<_$DeviceInfoImpl>(this, _$identity);
}

abstract class _DeviceInfo implements DeviceInfo {
  const factory _DeviceInfo({
    required final String id,
    required final String name,
    required final String macAddress,
    required final String firmwareVersion,
    required final int batteryLevel,
    final String? secretKey,
    required final int rssi,
  }) = _$DeviceInfoImpl;

  /// BLE remoteId
  @override
  String get id;

  /// 디바이스 이름 (예: Uneseule-001)
  @override
  String get name;

  /// MAC 주소
  @override
  String get macAddress;

  /// 펌웨어 버전
  @override
  String get firmwareVersion;

  /// 배터리 잔량 (0-100%)
  @override
  int get batteryLevel;

  /// 디바이스 고유 인증키
  @override
  String? get secretKey;

  /// BLE 신호 강도 (RSSI)
  @override
  int get rssi;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScannedDevice {
  /// BLE remoteId
  String get id => throw _privateConstructorUsedError;

  /// 디바이스 이름
  String get name => throw _privateConstructorUsedError;

  /// BLE 신호 강도 (RSSI)
  int get rssi => throw _privateConstructorUsedError;

  /// 연결 가능 여부
  bool get isConnectable => throw _privateConstructorUsedError;

  /// Create a copy of ScannedDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScannedDeviceCopyWith<ScannedDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannedDeviceCopyWith<$Res> {
  factory $ScannedDeviceCopyWith(
    ScannedDevice value,
    $Res Function(ScannedDevice) then,
  ) = _$ScannedDeviceCopyWithImpl<$Res, ScannedDevice>;
  @useResult
  $Res call({String id, String name, int rssi, bool isConnectable});
}

/// @nodoc
class _$ScannedDeviceCopyWithImpl<$Res, $Val extends ScannedDevice>
    implements $ScannedDeviceCopyWith<$Res> {
  _$ScannedDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScannedDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rssi = null,
    Object? isConnectable = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            rssi:
                null == rssi
                    ? _value.rssi
                    : rssi // ignore: cast_nullable_to_non_nullable
                        as int,
            isConnectable:
                null == isConnectable
                    ? _value.isConnectable
                    : isConnectable // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScannedDeviceImplCopyWith<$Res>
    implements $ScannedDeviceCopyWith<$Res> {
  factory _$$ScannedDeviceImplCopyWith(
    _$ScannedDeviceImpl value,
    $Res Function(_$ScannedDeviceImpl) then,
  ) = __$$ScannedDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int rssi, bool isConnectable});
}

/// @nodoc
class __$$ScannedDeviceImplCopyWithImpl<$Res>
    extends _$ScannedDeviceCopyWithImpl<$Res, _$ScannedDeviceImpl>
    implements _$$ScannedDeviceImplCopyWith<$Res> {
  __$$ScannedDeviceImplCopyWithImpl(
    _$ScannedDeviceImpl _value,
    $Res Function(_$ScannedDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScannedDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rssi = null,
    Object? isConnectable = null,
  }) {
    return _then(
      _$ScannedDeviceImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        rssi:
            null == rssi
                ? _value.rssi
                : rssi // ignore: cast_nullable_to_non_nullable
                    as int,
        isConnectable:
            null == isConnectable
                ? _value.isConnectable
                : isConnectable // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$ScannedDeviceImpl implements _ScannedDevice {
  const _$ScannedDeviceImpl({
    required this.id,
    required this.name,
    required this.rssi,
    required this.isConnectable,
  });

  /// BLE remoteId
  @override
  final String id;

  /// 디바이스 이름
  @override
  final String name;

  /// BLE 신호 강도 (RSSI)
  @override
  final int rssi;

  /// 연결 가능 여부
  @override
  final bool isConnectable;

  @override
  String toString() {
    return 'ScannedDevice(id: $id, name: $name, rssi: $rssi, isConnectable: $isConnectable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannedDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rssi, rssi) || other.rssi == rssi) &&
            (identical(other.isConnectable, isConnectable) ||
                other.isConnectable == isConnectable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, rssi, isConnectable);

  /// Create a copy of ScannedDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannedDeviceImplCopyWith<_$ScannedDeviceImpl> get copyWith =>
      __$$ScannedDeviceImplCopyWithImpl<_$ScannedDeviceImpl>(this, _$identity);
}

abstract class _ScannedDevice implements ScannedDevice {
  const factory _ScannedDevice({
    required final String id,
    required final String name,
    required final int rssi,
    required final bool isConnectable,
  }) = _$ScannedDeviceImpl;

  /// BLE remoteId
  @override
  String get id;

  /// 디바이스 이름
  @override
  String get name;

  /// BLE 신호 강도 (RSSI)
  @override
  int get rssi;

  /// 연결 가능 여부
  @override
  bool get isConnectable;

  /// Create a copy of ScannedDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScannedDeviceImplCopyWith<_$ScannedDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
