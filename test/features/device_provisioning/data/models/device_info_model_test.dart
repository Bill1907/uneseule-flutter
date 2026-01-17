import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uneseule_flutter/features/device_provisioning/data/models/device_info_model.dart';

void main() {
  group('DeviceInfoModel.fromBleData', () {
    test('정상적인 데이터로 모델 생성', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Uneseule-0001',
        macAddressBytes: [0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF],
        firmwareBytes: utf8.encode('1.0.0'),
        batteryLevel: 75,
        secretKeyBytes: utf8.encode('secret123'),
        rssi: -50,
      );

      expect(model.id, 'device123');
      expect(model.name, 'Uneseule-0001');
      expect(model.macAddress, 'AA:BB:CC:DD:EE:FF');
      expect(model.firmwareVersion, '1.0.0');
      expect(model.batteryLevel, 75);
      expect(model.secretKey, 'secret123');
      expect(model.rssi, -50);
    });

    test('빈 MAC 주소 바이트는 "Unknown" 반환', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [],
        firmwareBytes: [],
        batteryLevel: 50,
        rssi: -60,
      );

      expect(model.macAddress, 'Unknown');
    });

    test('빈 펌웨어 바이트는 빈 문자열 반환', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [0xAA],
        firmwareBytes: [],
        batteryLevel: 50,
        rssi: -60,
      );

      expect(model.firmwareVersion, '');
    });

    test('secretKeyBytes가 null인 경우', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [0xAA],
        firmwareBytes: [],
        batteryLevel: 50,
        secretKeyBytes: null,
        rssi: -60,
      );

      expect(model.secretKey, isNull);
    });

    test('배터리 레벨 범위 클램프 (100 초과)', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [],
        firmwareBytes: [],
        batteryLevel: 150, // 100 초과
        rssi: -60,
      );

      expect(model.batteryLevel, 100);
    });

    test('배터리 레벨 범위 클램프 (음수)', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [],
        firmwareBytes: [],
        batteryLevel: -10, // 음수
        rssi: -60,
      );

      expect(model.batteryLevel, 0);
    });

    test('NULL 문자가 포함된 펌웨어 버전 처리', () {
      // ESP32가 NULL 종료 문자열을 보낼 수 있음
      final firmwareWithNull = [0x31, 0x2E, 0x30, 0x2E, 0x30, 0x00, 0x00]; // "1.0.0\0\0"
      
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [],
        firmwareBytes: firmwareWithNull,
        batteryLevel: 50,
        rssi: -60,
      );

      expect(model.firmwareVersion, '1.0.0');
    });

    test('잘못된 UTF-8 펌웨어 바이트 처리', () {
      // 유효하지 않은 UTF-8 시퀀스
      final invalidUtf8 = [0xFF, 0xFE, 0xFD];
      
      // 예외가 발생하지 않아야 함
      expect(
        () => DeviceInfoModel.fromBleData(
          id: 'device123',
          name: 'Test',
          macAddressBytes: [],
          firmwareBytes: invalidUtf8,
          batteryLevel: 50,
          rssi: -60,
        ),
        returnsNormally,
      );
    });

    test('MAC 주소 바이트가 6바이트 미만인 경우', () {
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [0xAA, 0xBB], // 2바이트만
        firmwareBytes: [],
        batteryLevel: 50,
        rssi: -60,
      );

      expect(model.macAddress, 'AA:BB');
    });

    test('한글이 포함된 시크릿 키 처리', () {
      final koreanSecret = utf8.encode('시크릿키123');
      
      final model = DeviceInfoModel.fromBleData(
        id: 'device123',
        name: 'Test',
        macAddressBytes: [],
        firmwareBytes: [],
        batteryLevel: 50,
        secretKeyBytes: koreanSecret,
        rssi: -60,
      );

      expect(model.secretKey, '시크릿키123');
    });
  });

  group('DeviceInfoModel.toEntity', () {
    test('Entity로 정상 변환', () {
      final model = DeviceInfoModel(
        id: 'device123',
        name: 'Uneseule-0001',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        firmwareVersion: '1.0.0',
        batteryLevel: 75,
        secretKey: 'secret123',
        rssi: -50,
      );

      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.macAddress, model.macAddress);
      expect(entity.firmwareVersion, model.firmwareVersion);
      expect(entity.batteryLevel, model.batteryLevel);
      expect(entity.secretKey, model.secretKey);
      expect(entity.rssi, model.rssi);
    });
  });

  group('DeviceInfoModel JSON serialization', () {
    test('toJson/fromJson 왕복 테스트', () {
      final original = DeviceInfoModel(
        id: 'device123',
        name: 'Uneseule-0001',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        firmwareVersion: '1.0.0',
        batteryLevel: 75,
        secretKey: 'secret123',
        rssi: -50,
      );

      final json = original.toJson();
      final restored = DeviceInfoModel.fromJson(json);

      expect(restored, original);
    });

    test('secretKey가 null인 경우 JSON 직렬화', () {
      final model = DeviceInfoModel(
        id: 'device123',
        name: 'Test',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        firmwareVersion: '1.0.0',
        batteryLevel: 50,
        secretKey: null,
        rssi: -60,
      );

      final json = model.toJson();
      final restored = DeviceInfoModel.fromJson(json);

      expect(restored.secretKey, isNull);
    });
  });
}
