import 'dart:convert';

/// JavaScript Bridge 요청 메시지
class BridgeMessage {
  final String id;
  final String method;
  final Map<String, dynamic> params;

  const BridgeMessage({
    required this.id,
    required this.method,
    required this.params,
  });

  factory BridgeMessage.fromJson(Map<String, dynamic> json) {
    return BridgeMessage(
      id: json['id'] as String,
      method: json['method'] as String,
      params: (json['params'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method,
        'params': params,
      };

  @override
  String toString() => 'BridgeMessage(id: $id, method: $method, params: $params)';
}

/// JavaScript Bridge 응답 메시지
class BridgeResponse {
  final String id;
  final bool success;
  final dynamic data;
  final BridgeError? error;

  const BridgeResponse({
    required this.id,
    required this.success,
    this.data,
    this.error,
  });

  /// 성공 응답 생성
  factory BridgeResponse.success(String id, {dynamic data}) {
    return BridgeResponse(
      id: id,
      success: true,
      data: data,
    );
  }

  /// 에러 응답 생성
  factory BridgeResponse.failure(String id, BridgeError error) {
    return BridgeResponse(
      id: id,
      success: false,
      error: error,
    );
  }

  factory BridgeResponse.fromJson(Map<String, dynamic> json) {
    return BridgeResponse(
      id: json['id'] as String,
      success: json['success'] as bool,
      data: json['data'],
      error: json['error'] != null
          ? BridgeError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'success': success,
        if (data != null) 'data': data,
        if (error != null) 'error': error!.toJson(),
      };

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() =>
      'BridgeResponse(id: $id, success: $success, data: $data, error: $error)';
}

/// Bridge 에러 정보
class BridgeError {
  final int code;
  final String name;
  final String message;

  const BridgeError({
    required this.code,
    required this.name,
    required this.message,
  });

  factory BridgeError.fromJson(Map<String, dynamic> json) {
    return BridgeError(
      code: json['code'] as int,
      name: json['name'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'message': message,
      };

  @override
  String toString() => 'BridgeError(code: $code, name: $name, message: $message)';
}

/// Flutter에서 WebView로 전송하는 이벤트
class BridgeEvent {
  final String type;
  final Map<String, dynamic> payload;

  const BridgeEvent({
    required this.type,
    required this.payload,
  });

  factory BridgeEvent.fromJson(Map<String, dynamic> json) {
    return BridgeEvent(
      type: json['type'] as String,
      payload: (json['payload'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
      };

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => 'BridgeEvent(type: $type, payload: $payload)';
}
