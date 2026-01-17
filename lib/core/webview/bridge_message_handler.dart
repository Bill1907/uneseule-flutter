import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ble_bridge_service.dart';
import 'bridge_errors.dart';
import 'bridge_message.dart';
import 'permission_bridge_service.dart';

/// JavaScript Bridge 메시지 핸들러
class BridgeMessageHandler {
  final BleBridgeService _bleBridgeService;
  final PermissionBridgeService _permissionService;
  final WebViewController _controller;

  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration scanTimeout = Duration(seconds: 15);
  static const Duration connectTimeout = Duration(seconds: 30);

  BridgeMessageHandler(
    this._bleBridgeService,
    this._permissionService,
    this._controller,
  );

  /// JavaScript에서 호출된 메시지 처리
  Future<void> handleMessage(String messageJson) async {
    try {
      final json = jsonDecode(messageJson) as Map<String, dynamic>;
      final message = BridgeMessage.fromJson(json);

      _logRequest(message);

      final timeout = _getTimeoutForMethod(message.method);

      BridgeResponse response;
      try {
        final result = await _executeMethod(message).timeout(
          timeout,
          onTimeout: () {
            throw BridgeTimeoutException(message.method, timeout);
          },
        );
        response = BridgeResponse.success(message.id, data: result);
      } on BridgeException catch (e) {
        response = BridgeResponse.failure(
          message.id,
          BridgeError(
            code: e.errorCode.code,
            name: e.errorCode.name,
            message: e.message,
          ),
        );
      } catch (e) {
        response = BridgeResponse.failure(
          message.id,
          BridgeError(
            code: BridgeErrorCode.unknownError.code,
            name: BridgeErrorCode.unknownError.name,
            message: e.toString(),
          ),
        );
      }

      _logResponse(response);
      await _sendResponse(response);
    } catch (e, st) {
      debugPrint('[Bridge] Parse error: $e\n$st');
    }
  }

  /// 메서드별 타임아웃 설정
  Duration _getTimeoutForMethod(String method) {
    switch (method) {
      case 'scanDevices':
        return scanTimeout;
      case 'connectDevice':
        return connectTimeout;
      default:
        return defaultTimeout;
    }
  }

  /// 메서드 실행
  Future<dynamic> _executeMethod(BridgeMessage message) async {
    switch (message.method) {
      // === BLE API ===
      case 'isBluetoothEnabled':
        return await _bleBridgeService.isBluetoothEnabled();

      case 'scanDevices':
        await _bleBridgeService.scanDevices();
        return null;

      case 'stopScan':
        await _bleBridgeService.stopScan();
        return null;

      case 'connectDevice':
        final deviceId = message.params['deviceId'] as String;
        return await _bleBridgeService.connectDevice(deviceId);

      case 'disconnectDevice':
        await _bleBridgeService.disconnectDevice();
        return null;

      case 'readDeviceInfo':
        return await _bleBridgeService.readDeviceInfo();

      case 'sendWifiCredentials':
        final ssid = message.params['ssid'] as String;
        final password = message.params['password'] as String;
        await _bleBridgeService.sendWifiCredentials(ssid, password);
        return null;

      case 'sendProvisioningCommand':
        final command = message.params['command'] as int;
        await _bleBridgeService.sendProvisioningCommand(command);
        return null;

      // === Permission API ===
      case 'checkPermissions':
        return await _permissionService.checkBlePermissions();

      case 'requestPermissions':
        return await _permissionService.requestBlePermissions();

      case 'openSettings':
        final opened = await _permissionService.openAppSettings();
        return {'opened': opened};

      default:
        throw BridgeMethodNotFoundException(message.method);
    }
  }

  /// WebView로 응답 전송 (Base64 인코딩)
  Future<void> _sendResponse(BridgeResponse response) async {
    final json = response.toJsonString();
    final base64Json = base64Encode(utf8.encode(json));
    await _controller.runJavaScript(
      "window.uneseuleBridge && window.uneseuleBridge._onResponseBase64('$base64Json')",
    );
  }

  /// WebView로 이벤트 전송 (Base64 인코딩)
  Future<void> sendEvent(BridgeEvent event) async {
    _logEvent(event);
    final json = event.toJsonString();
    final base64Json = base64Encode(utf8.encode(json));
    await _controller.runJavaScript(
      "window.uneseuleBridge && window.uneseuleBridge._onEventBase64('$base64Json')",
    );
  }

  // === Logging ===

  void _logRequest(BridgeMessage message) {
    if (!kDebugMode) return;
    debugPrint('[Bridge] Request: ${message.method}');
    debugPrint('   ID: ${message.id}');
    debugPrint('   Params: ${message.params}');
  }

  void _logResponse(BridgeResponse response) {
    if (!kDebugMode) return;
    final status = response.success ? 'SUCCESS' : 'FAILED';
    debugPrint('[Bridge] Response: $status');
    debugPrint('   ID: ${response.id}');
    if (response.success) {
      debugPrint('   Data: ${response.data}');
    } else {
      debugPrint('   Error: ${response.error}');
    }
  }

  void _logEvent(BridgeEvent event) {
    if (!kDebugMode) return;
    debugPrint('[Bridge] Event: ${event.type}');
    debugPrint('   Payload: ${event.payload}');
  }
}
