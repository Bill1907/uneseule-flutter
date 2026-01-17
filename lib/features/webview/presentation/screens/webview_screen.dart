import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/webview/ble_bridge_service.dart';
import '../../../../core/webview/bridge_message.dart';
import '../../../../core/webview/bridge_message_handler.dart';
import '../../../../core/webview/bridge_state_sync.dart';
import '../../../../core/webview/permission_bridge_service.dart';
import '../../../device_provisioning/data/datasources/ble_datasource.dart';

/// WebView 기반 메인 화면
class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final WebViewController _controller;
  late final BleDataSource _bleDataSource;
  late final BleBridgeService _bleBridgeService;
  late final PermissionBridgeService _permissionService;
  late final BridgeMessageHandler _bridgeHandler;
  late final BridgeStateSync _bridgeStateSync;

  bool _isLoading = true;
  String? _errorMessage;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    // BLE DataSource 초기화
    _bleDataSource = BleDataSource();

    // Permission Service 초기화
    _permissionService = PermissionBridgeService();

    // WebView Controller 초기화
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onProgress: (progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            _injectBridgeScript();
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (request) {
            // 외부 URL 차단 (필요시)
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'UneseuleNative',
        onMessageReceived: (message) {
          _bridgeHandler.handleMessage(message.message);
        },
      );

    // Bridge Service 초기화
    _bleBridgeService = BleBridgeService(
      _bleDataSource,
      _onBridgeEvent,
    );

    // Bridge Handler 초기화
    _bridgeHandler = BridgeMessageHandler(
      _bleBridgeService,
      _permissionService,
      _controller,
    );

    // Bridge State Sync 초기화
    _bridgeStateSync = BridgeStateSync(
      _bleDataSource,
      _permissionService,
      (event) => _bridgeHandler.sendEvent(event),
    );

    // URL 로드
    _controller.loadRequest(Uri.parse(Environment.webAppUrl));
  }

  /// Bridge Event를 WebView로 전달
  void _onBridgeEvent(BridgeEvent event) {
    _bridgeHandler.sendEvent(event);
  }

  /// Bridge JavaScript 삽입
  Future<void> _injectBridgeScript() async {
    const bridgeScript = '''
      (function() {
        if (window.uneseuleBridge) return; // 이미 초기화됨

        window.uneseuleBridge = {
          // 요청 ID 생성
          _requestId: 0,
          _pendingRequests: {},

          // Base64 디코딩 헬퍼
          _decodeBase64: function(base64) {
            try {
              return decodeURIComponent(escape(atob(base64)));
            } catch (e) {
              console.error('[Bridge] Base64 decode error:', e);
              return null;
            }
          },

          // 네이티브 메서드 호출
          call: function(method, params) {
            return new Promise(function(resolve, reject) {
              var id = String(++window.uneseuleBridge._requestId);
              window.uneseuleBridge._pendingRequests[id] = { resolve: resolve, reject: reject };

              var message = JSON.stringify({
                id: id,
                method: method,
                params: params || {}
              });

              UneseuleNative.postMessage(message);

              // 30초 타임아웃
              setTimeout(function() {
                if (window.uneseuleBridge._pendingRequests[id]) {
                  delete window.uneseuleBridge._pendingRequests[id];
                  reject(new Error('Request timeout'));
                }
              }, 30000);
            });
          },

          // 네이티브 응답 처리 (Base64 인코딩된 버전)
          _onResponseBase64: function(base64) {
            var json = this._decodeBase64(base64);
            if (json) this.onResponse(json);
          },

          // 네이티브 응답 처리 (하위 호환성)
          onResponse: function(responseJson) {
            try {
              var response = JSON.parse(responseJson);
              var request = window.uneseuleBridge._pendingRequests[response.id];
              if (request) {
                delete window.uneseuleBridge._pendingRequests[response.id];
                if (response.success) {
                  request.resolve(response.data);
                } else {
                  // 에러 객체 또는 문자열 처리
                  var errorMsg = typeof response.error === 'object'
                    ? response.error.message
                    : response.error;
                  var error = new Error(errorMsg);
                  if (typeof response.error === 'object') {
                    error.code = response.error.code;
                    error.name = response.error.name;
                  }
                  request.reject(error);
                }
              }
            } catch (e) {
              console.error('[Bridge] Response parse error:', e);
            }
          },

          // 이벤트 리스너
          _eventListeners: {},

          on: function(eventType, callback) {
            if (!window.uneseuleBridge._eventListeners[eventType]) {
              window.uneseuleBridge._eventListeners[eventType] = [];
            }
            window.uneseuleBridge._eventListeners[eventType].push(callback);
          },

          off: function(eventType, callback) {
            if (window.uneseuleBridge._eventListeners[eventType]) {
              window.uneseuleBridge._eventListeners[eventType] =
                window.uneseuleBridge._eventListeners[eventType].filter(function(cb) {
                  return cb !== callback;
                });
            }
          },

          // 네이티브 이벤트 처리 (Base64 인코딩된 버전)
          _onEventBase64: function(base64) {
            var json = this._decodeBase64(base64);
            if (json) this.onEvent(json);
          },

          // 네이티브 이벤트 처리 (하위 호환성)
          onEvent: function(eventJson) {
            try {
              var event = JSON.parse(eventJson);
              var listeners = window.uneseuleBridge._eventListeners[event.type];
              if (listeners) {
                listeners.forEach(function(cb) { cb(event.payload); });
              }
            } catch (e) {
              console.error('[Bridge] Event parse error:', e);
            }
          },

          // === BLE API ===
          ble: {
            isBluetoothEnabled: function() {
              return window.uneseuleBridge.call('isBluetoothEnabled');
            },
            scanDevices: function() {
              return window.uneseuleBridge.call('scanDevices');
            },
            stopScan: function() {
              return window.uneseuleBridge.call('stopScan');
            },
            connect: function(deviceId) {
              return window.uneseuleBridge.call('connectDevice', { deviceId: deviceId });
            },
            disconnect: function() {
              return window.uneseuleBridge.call('disconnectDevice');
            },
            readDeviceInfo: function() {
              return window.uneseuleBridge.call('readDeviceInfo');
            },
            sendWifiCredentials: function(ssid, password) {
              return window.uneseuleBridge.call('sendWifiCredentials', { ssid: ssid, password: password });
            },
            sendProvisioningCommand: function(command) {
              return window.uneseuleBridge.call('sendProvisioningCommand', { command: command });
            }
          },

          // === Permission API ===
          permissions: {
            check: function() {
              return window.uneseuleBridge.call('checkPermissions');
            },
            request: function() {
              return window.uneseuleBridge.call('requestPermissions');
            },
            openSettings: function() {
              return window.uneseuleBridge.call('openSettings');
            }
          }
        };

        // Bridge 준비 완료 이벤트 발행
        window.dispatchEvent(new CustomEvent('uneseuleBridgeReady'));
        console.log('[Bridge] Uneseule Bridge initialized');
      })();
    ''';

    await _controller.runJavaScript(bridgeScript);

    // 초기 상태 동기화
    await _bridgeStateSync.syncInitialState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // WebView
            WebViewWidget(controller: _controller),

            // 로딩 인디케이터
            if (_isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _loadingProgress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),

            // 에러 화면
            if (_errorMessage != null) _buildErrorScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                '연결 오류',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage ?? '알 수 없는 오류가 발생했습니다',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    _controller.reload();
  }

  @override
  void dispose() {
    _bleBridgeService.dispose();
    _bleDataSource.dispose();
    super.dispose();
  }
}
