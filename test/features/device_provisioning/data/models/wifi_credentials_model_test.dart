import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uneseule_flutter/features/device_provisioning/data/models/wifi_credentials_model.dart';
import 'package:uneseule_flutter/features/device_provisioning/domain/entities/wifi_status.dart';

void main() {
  group('WifiCredentialsModel', () {
    test('기본 영문 SSID와 비밀번호 인코딩', () {
      final model = WifiCredentialsModel(
        ssid: 'MyWiFi',
        password: 'password123',
      );

      expect(model.ssidBytes, utf8.encode('MyWiFi'));
      expect(model.passwordBytes, utf8.encode('password123'));
    });

    test('한글 SSID 인코딩', () {
      final model = WifiCredentialsModel(
        ssid: '우리집와이파이',
        password: 'password123',
      );

      expect(model.ssidBytes, utf8.encode('우리집와이파이'));
      expect(utf8.decode(model.ssidBytes), '우리집와이파이');
    });

    test('특수문자 포함 비밀번호 인코딩', () {
      final model = WifiCredentialsModel(
        ssid: 'TestSSID',
        password: 'p@ss\$word!#%^&*()',
      );

      expect(model.passwordBytes, utf8.encode('p@ss\$word!#%^&*()'));
      expect(utf8.decode(model.passwordBytes), 'p@ss\$word!#%^&*()');
    });

    test('이모지 포함 SSID 인코딩', () {
      final model = WifiCredentialsModel(
        ssid: '🏠 Home WiFi',
        password: 'password',
      );

      expect(model.ssidBytes, utf8.encode('🏠 Home WiFi'));
      expect(utf8.decode(model.ssidBytes), '🏠 Home WiFi');
    });

    test('빈 SSID 인코딩', () {
      final model = WifiCredentialsModel(
        ssid: '',
        password: 'password123',
      );

      expect(model.ssidBytes, isEmpty);
    });

    test('빈 비밀번호 인코딩 (오픈 네트워크)', () {
      final model = WifiCredentialsModel(
        ssid: 'OpenNetwork',
        password: '',
      );

      expect(model.passwordBytes, isEmpty);
    });

    test('매우 긴 SSID (32바이트 제한 확인)', () {
      // WiFi SSID는 최대 32바이트
      final longSsid = 'A' * 50;
      final model = WifiCredentialsModel(
        ssid: longSsid,
        password: 'password',
      );

      // 인코딩 자체는 성공해야 함
      expect(model.ssidBytes.length, 50);
      // 주의: 실제 전송 시 ESP32에서 잘릴 수 있음
    });

    test('매우 긴 비밀번호 (63바이트 제한 확인)', () {
      // WPA2 비밀번호는 최대 63바이트
      final longPassword = 'P' * 100;
      final model = WifiCredentialsModel(
        ssid: 'TestSSID',
        password: longPassword,
      );

      // 인코딩 자체는 성공해야 함
      expect(model.passwordBytes.length, 100);
      // 주의: 실제 전송 시 ESP32에서 잘릴 수 있음
    });

    test('fromEntity 팩토리 생성자', () {
      final entity = WifiCredentials(
        ssid: 'EntitySSID',
        password: 'EntityPassword',
      );

      final model = WifiCredentialsModel.fromEntity(entity);

      expect(model.ssid, entity.ssid);
      expect(model.password, entity.password);
    });

    test('공백이 포함된 SSID', () {
      final model = WifiCredentialsModel(
        ssid: '  Network With Spaces  ',
        password: 'password',
      );

      // 공백이 보존되어야 함
      expect(utf8.decode(model.ssidBytes), '  Network With Spaces  ');
    });

    test('NULL 문자가 포함된 경우 자동 필터링', () {
      // NULL 문자가 포함된 입력 - ESP32 C 문자열 호환성을 위해 필터링됨
      final model = WifiCredentialsModel(
        ssid: 'Test\x00SSID',
        password: 'pass\x00word',
      );

      // NULL 문자는 필터링되어야 함
      expect(model.ssidBytes.contains(0), isFalse);
      expect(model.passwordBytes.contains(0), isFalse);
      
      // 원본에서 NULL을 제거한 결과와 같아야 함
      expect(utf8.decode(model.ssidBytes), 'TestSSID');
      expect(utf8.decode(model.passwordBytes), 'password');
    });
  });

  group('WifiCredentialsModel 바이트 길이 검증', () {
    test('한글 SSID 바이트 길이 (UTF-8은 한글당 3바이트)', () {
      final model = WifiCredentialsModel(
        ssid: '테스트', // 3글자 * 3바이트 = 9바이트
        password: 'password',
      );

      expect(model.ssidBytes.length, 9);
    });

    test('혼합 문자열 바이트 길이 계산', () {
      final model = WifiCredentialsModel(
        ssid: 'My네트워크', // 2 + 12 = 14바이트
        password: 'password',
      );

      expect(model.ssidBytes.length, 14);
    });
  });
}
