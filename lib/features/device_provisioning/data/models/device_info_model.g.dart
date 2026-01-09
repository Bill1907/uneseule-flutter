// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceInfoModelImpl _$$DeviceInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeviceInfoModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  macAddress: json['macAddress'] as String,
  firmwareVersion: json['firmwareVersion'] as String,
  batteryLevel: (json['batteryLevel'] as num).toInt(),
  secretKey: json['secretKey'] as String?,
  rssi: (json['rssi'] as num).toInt(),
);

Map<String, dynamic> _$$DeviceInfoModelImplToJson(
  _$DeviceInfoModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'macAddress': instance.macAddress,
  'firmwareVersion': instance.firmwareVersion,
  'batteryLevel': instance.batteryLevel,
  'secretKey': instance.secretKey,
  'rssi': instance.rssi,
};
