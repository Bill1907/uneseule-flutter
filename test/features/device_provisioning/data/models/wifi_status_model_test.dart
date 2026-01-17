import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uneseule_flutter/features/device_provisioning/data/models/wifi_credentials_model.dart';
import 'package:uneseule_flutter/features/device_provisioning/domain/entities/wifi_status.dart';
import 'package:uneseule_flutter/core/constants/ble_constants.dart';

void main() {
  group('WifiStatusModel.fromBytes', () {
    test('빈 바이트 배열은 disconnected 상태 반환', () {
      final model = WifiStatusModel.fromBytes([]);
      
      expect(model.statusCode, BleConstants.wifiStatusDisconnected);
      expect(model.ssid, isNull);
      expect(model.ipAddress, isNull);
    });

    test('상태 코드만 있는 경우 정상 파싱', () {
      final model = WifiStatusModel.fromBytes([BleConstants.wifiStatusConnecting]);
      
      expect(model.statusCode, BleConstants.wifiStatusConnecting);
      expect(model.ssid, isNull);
    });

    test('정상적인 SSID와 IP 주소 파싱', () {
      final ssid = 'TestWiFi';
      final ip = '192.168.1.1';
      final ssidBytes = utf8.encode(ssid);
      final ipBytes = utf8.encode(ip);
      
      final bytes = [
        BleConstants.wifiStatusConnected, // status
        ssidBytes.length, // ssid_len
        ...ssidBytes, // ssid
        ipBytes.length, // ip_len
        ...ipBytes, // ip
      ];
      
      final model = WifiStatusModel.fromBytes(bytes);
      
      expect(model.statusCode, BleConstants.wifiStatusConnected);
      expect(model.ssid, ssid);
      expect(model.ipAddress, ip);
    });

    test('잘못된 ssidLen (너무 큰 값) 처리', () {
      // ssidLen이 실제 데이터보다 큰 경우
      final bytes = [
        BleConstants.wifiStatusConnected,
        255, // ssid_len: 매우 큰 값
        65, 66, 67, // 실제로는 3바이트만 있음
      ];
      
      // 범위를 벗어나므로 SSID가 null이어야 함
      final model = WifiStatusModel.fromBytes(bytes);
      expect(model.ssid, isNull);
    });

    test('ssidLen이 0인 경우', () {
      final bytes = [
        BleConstants.wifiStatusConnected,
        0, // ssid_len: 0
      ];
      
      final model = WifiStatusModel.fromBytes(bytes);
      expect(model.ssid, isNull);
    });

    test('잘못된 UTF-8 바이트 처리', () {
      // 유효하지 않은 UTF-8 시퀀스
      final bytes = [
        BleConstants.wifiStatusConnected,
        3, // ssid_len
        0xFF, 0xFE, 0xFD, // 잘못된 UTF-8
      ];
      
      // 예외가 발생하지 않아야 함
      expect(() => WifiStatusModel.fromBytes(bytes), returnsNormally);
      final model = WifiStatusModel.fromBytes(bytes);
      // UTF-8 디코딩 실패 시 null
      expect(model.ssid, isNull);
    });

    test('IP 주소 길이가 부정확한 경우', () {
      final ssid = 'Test';
      final ssidBytes = utf8.encode(ssid);
      
      final bytes = [
        BleConstants.wifiStatusConnected,
        ssidBytes.length,
        ...ssidBytes,
        100, // ip_len: 100 (실제 데이터 없음)
      ];
      
      final model = WifiStatusModel.fromBytes(bytes);
      expect(model.ssid, ssid);
      expect(model.ipAddress, isNull);
    });

    test('toEntity() 상태 변환 검증', () {
      final testCases = [
        (BleConstants.wifiStatusDisconnected, WifiConnectionState.disconnected),
        (BleConstants.wifiStatusConnecting, WifiConnectionState.connecting),
        (BleConstants.wifiStatusConnected, WifiConnectionState.connected),
        (BleConstants.wifiStatusFailed, WifiConnectionState.failed),
        (BleConstants.wifiStatusWrongPassword, WifiConnectionState.wrongPassword),
        (BleConstants.wifiStatusNoAp, WifiConnectionState.noAccessPoint),
      ];
      
      for (final (code, expectedState) in testCases) {
        final model = WifiStatusModel.fromBytes([code]);
        final entity = model.toEntity();
        expect(entity.state, expectedState, reason: 'Status code $code should map to $expectedState');
      }
    });

    test('알 수 없는 상태 코드는 failed로 처리', () {
      final model = WifiStatusModel.fromBytes([99]); // 정의되지 않은 코드
      final entity = model.toEntity();
      
      expect(entity.state, WifiConnectionState.failed);
    });

    test('에러 메시지 생성 검증', () {
      final failedModel = WifiStatusModel.fromBytes([BleConstants.wifiStatusFailed]);
      expect(failedModel.toEntity().errorMessage, isNotNull);
      
      final wrongPwModel = WifiStatusModel.fromBytes([BleConstants.wifiStatusWrongPassword]);
      expect(wrongPwModel.toEntity().errorMessage, contains('비밀번호'));
      
      final noApModel = WifiStatusModel.fromBytes([BleConstants.wifiStatusNoAp]);
      expect(noApModel.toEntity().errorMessage, contains('찾을 수 없습니다'));
    });
  });
}
