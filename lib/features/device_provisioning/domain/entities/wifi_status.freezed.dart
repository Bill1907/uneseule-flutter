// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wifi_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WifiStatus {
  /// 연결 상태
  WifiConnectionState get state => throw _privateConstructorUsedError;

  /// 연결된 SSID
  String? get ssid => throw _privateConstructorUsedError;

  /// 할당된 IP 주소
  String? get ipAddress => throw _privateConstructorUsedError;

  /// 에러 메시지
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of WifiStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WifiStatusCopyWith<WifiStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WifiStatusCopyWith<$Res> {
  factory $WifiStatusCopyWith(
    WifiStatus value,
    $Res Function(WifiStatus) then,
  ) = _$WifiStatusCopyWithImpl<$Res, WifiStatus>;
  @useResult
  $Res call({
    WifiConnectionState state,
    String? ssid,
    String? ipAddress,
    String? errorMessage,
  });
}

/// @nodoc
class _$WifiStatusCopyWithImpl<$Res, $Val extends WifiStatus>
    implements $WifiStatusCopyWith<$Res> {
  _$WifiStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WifiStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? ssid = freezed,
    Object? ipAddress = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            state:
                null == state
                    ? _value.state
                    : state // ignore: cast_nullable_to_non_nullable
                        as WifiConnectionState,
            ssid:
                freezed == ssid
                    ? _value.ssid
                    : ssid // ignore: cast_nullable_to_non_nullable
                        as String?,
            ipAddress:
                freezed == ipAddress
                    ? _value.ipAddress
                    : ipAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WifiStatusImplCopyWith<$Res>
    implements $WifiStatusCopyWith<$Res> {
  factory _$$WifiStatusImplCopyWith(
    _$WifiStatusImpl value,
    $Res Function(_$WifiStatusImpl) then,
  ) = __$$WifiStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WifiConnectionState state,
    String? ssid,
    String? ipAddress,
    String? errorMessage,
  });
}

/// @nodoc
class __$$WifiStatusImplCopyWithImpl<$Res>
    extends _$WifiStatusCopyWithImpl<$Res, _$WifiStatusImpl>
    implements _$$WifiStatusImplCopyWith<$Res> {
  __$$WifiStatusImplCopyWithImpl(
    _$WifiStatusImpl _value,
    $Res Function(_$WifiStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WifiStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? ssid = freezed,
    Object? ipAddress = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$WifiStatusImpl(
        state:
            null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                    as WifiConnectionState,
        ssid:
            freezed == ssid
                ? _value.ssid
                : ssid // ignore: cast_nullable_to_non_nullable
                    as String?,
        ipAddress:
            freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$WifiStatusImpl implements _WifiStatus {
  const _$WifiStatusImpl({
    required this.state,
    this.ssid,
    this.ipAddress,
    this.errorMessage,
  });

  /// 연결 상태
  @override
  final WifiConnectionState state;

  /// 연결된 SSID
  @override
  final String? ssid;

  /// 할당된 IP 주소
  @override
  final String? ipAddress;

  /// 에러 메시지
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'WifiStatus(state: $state, ssid: $ssid, ipAddress: $ipAddress, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WifiStatusImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.ssid, ssid) || other.ssid == ssid) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, state, ssid, ipAddress, errorMessage);

  /// Create a copy of WifiStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WifiStatusImplCopyWith<_$WifiStatusImpl> get copyWith =>
      __$$WifiStatusImplCopyWithImpl<_$WifiStatusImpl>(this, _$identity);
}

abstract class _WifiStatus implements WifiStatus {
  const factory _WifiStatus({
    required final WifiConnectionState state,
    final String? ssid,
    final String? ipAddress,
    final String? errorMessage,
  }) = _$WifiStatusImpl;

  /// 연결 상태
  @override
  WifiConnectionState get state;

  /// 연결된 SSID
  @override
  String? get ssid;

  /// 할당된 IP 주소
  @override
  String? get ipAddress;

  /// 에러 메시지
  @override
  String? get errorMessage;

  /// Create a copy of WifiStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WifiStatusImplCopyWith<_$WifiStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WifiCredentials {
  /// WiFi 네트워크 이름
  String get ssid => throw _privateConstructorUsedError;

  /// WiFi 비밀번호
  String get password => throw _privateConstructorUsedError;

  /// Create a copy of WifiCredentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WifiCredentialsCopyWith<WifiCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WifiCredentialsCopyWith<$Res> {
  factory $WifiCredentialsCopyWith(
    WifiCredentials value,
    $Res Function(WifiCredentials) then,
  ) = _$WifiCredentialsCopyWithImpl<$Res, WifiCredentials>;
  @useResult
  $Res call({String ssid, String password});
}

/// @nodoc
class _$WifiCredentialsCopyWithImpl<$Res, $Val extends WifiCredentials>
    implements $WifiCredentialsCopyWith<$Res> {
  _$WifiCredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WifiCredentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ssid = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            ssid:
                null == ssid
                    ? _value.ssid
                    : ssid // ignore: cast_nullable_to_non_nullable
                        as String,
            password:
                null == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WifiCredentialsImplCopyWith<$Res>
    implements $WifiCredentialsCopyWith<$Res> {
  factory _$$WifiCredentialsImplCopyWith(
    _$WifiCredentialsImpl value,
    $Res Function(_$WifiCredentialsImpl) then,
  ) = __$$WifiCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ssid, String password});
}

/// @nodoc
class __$$WifiCredentialsImplCopyWithImpl<$Res>
    extends _$WifiCredentialsCopyWithImpl<$Res, _$WifiCredentialsImpl>
    implements _$$WifiCredentialsImplCopyWith<$Res> {
  __$$WifiCredentialsImplCopyWithImpl(
    _$WifiCredentialsImpl _value,
    $Res Function(_$WifiCredentialsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WifiCredentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ssid = null, Object? password = null}) {
    return _then(
      _$WifiCredentialsImpl(
        ssid:
            null == ssid
                ? _value.ssid
                : ssid // ignore: cast_nullable_to_non_nullable
                    as String,
        password:
            null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$WifiCredentialsImpl implements _WifiCredentials {
  const _$WifiCredentialsImpl({required this.ssid, required this.password});

  /// WiFi 네트워크 이름
  @override
  final String ssid;

  /// WiFi 비밀번호
  @override
  final String password;

  @override
  String toString() {
    return 'WifiCredentials(ssid: $ssid, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WifiCredentialsImpl &&
            (identical(other.ssid, ssid) || other.ssid == ssid) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ssid, password);

  /// Create a copy of WifiCredentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WifiCredentialsImplCopyWith<_$WifiCredentialsImpl> get copyWith =>
      __$$WifiCredentialsImplCopyWithImpl<_$WifiCredentialsImpl>(
        this,
        _$identity,
      );
}

abstract class _WifiCredentials implements WifiCredentials {
  const factory _WifiCredentials({
    required final String ssid,
    required final String password,
  }) = _$WifiCredentialsImpl;

  /// WiFi 네트워크 이름
  @override
  String get ssid;

  /// WiFi 비밀번호
  @override
  String get password;

  /// Create a copy of WifiCredentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WifiCredentialsImplCopyWith<_$WifiCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
