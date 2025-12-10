/// Environment configuration for the application
///
/// Manages different environment configurations (dev, staging, prod)
/// and provides appropriate API URLs and settings for each.
class Environment {
  /// Current environment type
  static EnvironmentType get current {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    return EnvironmentType.values.firstWhere(
      (e) => e.name == env,
      orElse: () => EnvironmentType.dev,
    );
  }

  /// Base URL for API calls based on current environment
  static String get apiBaseUrl {
    switch (current) {
      case EnvironmentType.prod:
        return 'https://api.yunseul.com';
      case EnvironmentType.staging:
        return 'https://staging-api.yunseul.com';
      case EnvironmentType.dev:
        return 'https://dev-api.yunseul.com';
    }
  }

  /// WebSocket URL for signaling server
  static String get signalingServerUrl {
    switch (current) {
      case EnvironmentType.prod:
        return 'wss://api.yunseul.com/signaling';
      case EnvironmentType.staging:
        return 'wss://staging-api.yunseul.com/signaling';
      case EnvironmentType.dev:
        return 'wss://dev-api.yunseul.com/signaling';
    }
  }

  /// Whether to enable debug logging
  static bool get enableDebugLogs {
    return current != EnvironmentType.prod;
  }

  /// API timeout duration
  static Duration get apiTimeout {
    return const Duration(seconds: 30);
  }
}

/// Environment types
enum EnvironmentType {
  dev,
  staging,
  prod,
}
