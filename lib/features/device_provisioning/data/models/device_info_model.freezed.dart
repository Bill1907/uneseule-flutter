// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeviceInfoModel _$DeviceInfoModelFromJson(Map<String, dynamic> json) {
  return _DeviceInfoModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfoModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get macAddress => throw _privateConstructorUsedError;
  String get firmwareVersion => throw _privateConstructorUsedError;
  int get batteryLevel => throw _privateConstructorUsedError;
  String? get secretKey => throw _privateConstructorUsedError;
  int get rssi => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoModelCopyWith<DeviceInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoModelCopyWith<$Res> {
  factory $DeviceInfoModelCopyWith(
    DeviceInfoModel value,
    $Res Function(DeviceInfoModel) then,
  ) = _$DeviceInfoModelCopyWithImpl<$Res, DeviceInfoModel>;
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
class _$DeviceInfoModelCopyWithImpl<$Res, $Val extends DeviceInfoModel>
    implements $DeviceInfoModelCopyWith<$Res> {
  _$DeviceInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfoModel
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
abstract class _$$DeviceInfoModelImplCopyWith<$Res>
    implements $DeviceInfoModelCopyWith<$Res> {
  factory _$$DeviceInfoModelImplCopyWith(
    _$DeviceInfoModelImpl value,
    $Res Function(_$DeviceInfoModelImpl) then,
  ) = __$$DeviceInfoModelImplCopyWithImpl<$Res>;
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
class __$$DeviceInfoModelImplCopyWithImpl<$Res>
    extends _$DeviceInfoModelCopyWithImpl<$Res, _$DeviceInfoModelImpl>
    implements _$$DeviceInfoModelImplCopyWith<$Res> {
  __$$DeviceInfoModelImplCopyWithImpl(
    _$DeviceInfoModelImpl _value,
    $Res Function(_$DeviceInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceInfoModel
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
      _$DeviceInfoModelImpl(
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
@JsonSerializable()
class _$DeviceInfoModelImpl extends _DeviceInfoModel {
  const _$DeviceInfoModelImpl({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.firmwareVersion,
    required this.batteryLevel,
    this.secretKey,
    required this.rssi,
  }) : super._();

  factory _$DeviceInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String macAddress;
  @override
  final String firmwareVersion;
  @override
  final int batteryLevel;
  @override
  final String? secretKey;
  @override
  final int rssi;

  @override
  String toString() {
    return 'DeviceInfoModel(id: $id, name: $name, macAddress: $macAddress, firmwareVersion: $firmwareVersion, batteryLevel: $batteryLevel, secretKey: $secretKey, rssi: $rssi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoModelImplCopyWith<_$DeviceInfoModelImpl> get copyWith =>
      __$$DeviceInfoModelImplCopyWithImpl<_$DeviceInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoModelImplToJson(this);
  }
}

abstract class _DeviceInfoModel extends DeviceInfoModel {
  const factory _DeviceInfoModel({
    required final String id,
    required final String name,
    required final String macAddress,
    required final String firmwareVersion,
    required final int batteryLevel,
    final String? secretKey,
    required final int rssi,
  }) = _$DeviceInfoModelImpl;
  const _DeviceInfoModel._() : super._();

  factory _DeviceInfoModel.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get macAddress;
  @override
  String get firmwareVersion;
  @override
  int get batteryLevel;
  @override
  String? get secretKey;
  @override
  int get rssi;

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoModelImplCopyWith<_$DeviceInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
