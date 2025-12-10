# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Product**: Voice AI Companion Doll (윤슬 - Yunseul)
**Framework**: Flutter 3.29.2 with Dart 3.7.2
**Target**: MVP launch within 3 months
**Architecture**: Flutter mobile app + BLE device communication + WebRTC streaming

This is a Flutter-based mobile application for a voice AI companion doll that enables real-time conversations between children (ages 3-10) and an AI assistant. The app serves as a communication bridge between a Bluetooth-enabled doll device and cloud-based AI services, while providing parents with monitoring and safety features.

### Core Architecture

```
[Doll Device (BLE)] ↔ (Bluetooth Classic HFP) ↔ [Flutter App] → (WebRTC) → [Backend Server]
                                                        ↓
                                                 [Parent Dashboard]
                                                        ↓
                                              [Safety Monitoring System]
```

### Key Technical Decisions

- **Flutter over React Native**: Native performance, better Bluetooth integration, single codebase
- **Bluetooth Classic HFP**: Proven audio streaming, low latency (50-100ms), 16kHz audio
- **WebRTC**: Real-time bidirectional audio streaming to backend
- **ElevenLabs API**: Integrated STT → LLM → TTS pipeline for rapid MVP

---

## Development Commands

### Core Flutter Commands

```bash
# Run the app (default: debug mode)
flutter run

# Run on specific device
flutter run -d <device-id>
flutter devices  # List available devices

# Hot reload (press 'r' in terminal while app is running)
# Hot restart (press 'R' in terminal while app is running)

# Build for production
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle (for Play Store)
flutter build ios          # iOS (requires macOS + Xcode)

# Run with flavor (if configured)
flutter run --flavor dev
flutter run --flavor prod
```

### Code Quality

```bash
# Run static analysis
flutter analyze

# Run all tests
flutter test

# Run integration tests
flutter test integration_test/

# Run a single test file
flutter test test/features/conversation/conversation_test.dart

# Run tests with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html  # Generate HTML report
```

### Dependencies

```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Clean build artifacts
flutter clean
flutter pub get  # Re-fetch after clean

# Generate code (freezed, json_serializable, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
dart run build_runner watch --delete-conflicting-outputs
```

### Bluetooth Development

```bash
# Check Bluetooth permissions (Android)
adb shell dumpsys bluetooth_manager

# Monitor Bluetooth logs
adb logcat | grep -i bluetooth

# Test on physical device (Bluetooth requires real hardware)
flutter run -d <physical-device-id>
```

---

## Project Structure

```
lib/
  main.dart                    # Application entry point
  core/
    constants/                 # App constants, API keys
    theme/                     # Theme configuration
    utils/                     # Utility functions
  features/
    auth/                      # Authentication
      data/                    # Data layer (repositories, data sources)
      domain/                  # Domain layer (entities, use cases)
      presentation/            # Presentation layer (widgets, providers)
    conversation/              # Real-time conversation feature
      bluetooth/               # Bluetooth Classic HFP integration
      webrtc/                  # WebRTC streaming
      presentation/            # Conversation UI
    parent_dashboard/          # Parent monitoring features
      conversation_logs/       # View conversation history
      safety_alerts/           # Risk notifications
      settings/                # Parental controls
    device_pairing/            # Device pairing flow
  shared/
    widgets/                   # Reusable UI components
    services/                  # Global services
test/
  features/                    # Feature tests (mirror lib structure)
  helpers/                     # Test helpers and mocks
integration_test/              # E2E tests
```

### Architecture Pattern: Clean Architecture + Riverpod

- **Presentation**: Widgets + Riverpod providers
- **Domain**: Use cases, entities
- **Data**: Repositories, data sources (API, Bluetooth, WebRTC)

---

## Key Features Implementation

### 1. Bluetooth Classic HFP Integration

**Critical Requirements**:
- Bluetooth Classic (not BLE) for audio streaming
- HFP (Hands-Free Profile) for bidirectional voice
- Audio codec: mSBC (Modified SBC), 16kHz, 60 kbps
- Target latency: <100ms

**Recommended Packages**:
```yaml
dependencies:
  flutter_bluetooth_serial: ^0.4.0  # Android Bluetooth Classic
  # Note: iOS requires different approach (External Accessory Framework)
```

**Key Implementation Points**:
```dart
// Bluetooth connection management
class BluetoothService {
  // 1. Scan for doll device (name: "윤슬")
  Future<List<BluetoothDevice>> scanDevices();

  // 2. Connect to device
  Future<BluetoothConnection> connect(BluetoothDevice device);

  // 3. Handle audio streaming
  Stream<Uint8List> receiveAudioStream();  // From doll microphone
  Future<void> sendAudioStream(Uint8List audioData);  // To doll speaker

  // 4. Auto-reconnection (every 3 seconds)
  Future<void> handleDisconnection();
}
```

**Platform-Specific Notes**:
- **Android**: Use `flutter_bluetooth_serial`, request BLUETOOTH permissions
- **iOS**: Requires MFi certification for Bluetooth Classic audio, consider BLE alternative

### 2. WebRTC Integration

**Purpose**: Stream audio from Flutter app to backend server

**Recommended Packages**:
```yaml
dependencies:
  flutter_webrtc: ^0.9.0
```

**Data Flow**:
```
Doll Mic → BT → Flutter → WebRTC → Backend → ElevenLabs API
                           ↓
Backend Response → WebRTC → Flutter → BT → Doll Speaker
```

**Key Implementation**:
```dart
class WebRTCService {
  RTCPeerConnection? peerConnection;

  // 1. Initialize WebRTC connection
  Future<void> initialize(String signalingServerUrl);

  // 2. Send audio to backend
  Future<void> sendAudio(Uint8List audioData);

  // 3. Receive AI response audio
  Stream<Uint8List> receiveAudio();

  // 4. Handle connection state
  void onConnectionStateChange(RTCPeerConnectionState state);
}
```

### 3. Parent Dashboard Features

**Must Have (MVP)**:
- Conversation log list (today's conversations)
- Risk alert notifications (FCM push)
- Child profile creation
- Device pairing

**Should Have**:
- Emotion tagging (5 categories)
- Custom forbidden words
- Daily usage time limits
- Weekly reports

**State Management with Riverpod**:
```dart
@riverpod
class ConversationLogs extends _$ConversationLogs {
  @override
  Future<List<Conversation>> build() async {
    return ref.watch(conversationRepositoryProvider).fetchLogs();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
      ref.read(conversationRepositoryProvider).fetchLogs()
    );
  }
}
```

---

## Technology Stack

### Core Framework
- **Flutter**: 3.29.2
- **Dart**: 3.7.2

### State Management
- **Riverpod**: ^2.4.0 (recommended over Provider)
- **Freezed**: For immutable data classes
- **Async State**: AsyncValue pattern for loading states

### Navigation
- **go_router**: ^13.0.0 (declarative routing)

### Network & API
- **dio**: ^5.4.0 (HTTP client)
- **json_serializable**: For JSON parsing
- **retrofit**: (optional) For type-safe API calls

### Real-time Communication
- **flutter_webrtc**: ^0.9.0 (WebRTC)
- **flutter_bluetooth_serial**: ^0.4.0 (Android Bluetooth Classic)
- **web_socket_channel**: ^2.4.0 (WebSocket signaling)

### Local Storage
- **shared_preferences**: For simple key-value storage
- **hive**: (optional) For complex local data
- **secure_storage**: For sensitive data (JWT tokens)

### Push Notifications
- **firebase_messaging**: ^14.7.0
- **flutter_local_notifications**: For foreground notifications

### UI & Design
- **flutter_svg**: SVG support
- **cached_network_image**: Image caching
- **shimmer**: Loading skeleton screens

### Testing
- **mocktail**: Mocking framework
- **flutter_test**: Built-in test framework
- **integration_test**: E2E testing

### Code Generation
- **build_runner**: Code generation
- **freezed**: Immutable models
- **json_serializable**: JSON serialization

---

## Development Workflow

### 1. Feature Development Pattern

```bash
# 1. Create feature branch
git checkout -b feature/conversation-ui

# 2. Generate boilerplate (if needed)
flutter create --template=package lib/features/new_feature

# 3. Implement following Clean Architecture
# - Create domain entities
# - Create use cases
# - Create repository interfaces
# - Implement data sources
# - Build UI with Riverpod

# 4. Write tests
flutter test test/features/new_feature/

# 5. Run analysis
flutter analyze

# 6. Create PR
git push origin feature/conversation-ui
```

### 2. State Management Pattern (Riverpod)

```dart
// 1. Define state class (immutable with freezed)
@freezed
class ConversationState with _$ConversationState {
  const factory ConversationState({
    required List<Message> messages,
    required bool isRecording,
    required ConnectionStatus bluetoothStatus,
    required ConnectionStatus webrtcStatus,
  }) = _ConversationState;
}

// 2. Create provider
@riverpod
class Conversation extends _$Conversation {
  @override
  ConversationState build() {
    return const ConversationState(
      messages: [],
      isRecording: false,
      bluetoothStatus: ConnectionStatus.disconnected,
      webrtcStatus: ConnectionStatus.disconnected,
    );
  }

  Future<void> startRecording() async {
    state = state.copyWith(isRecording: true);
    // Implementation...
  }
}

// 3. Use in widget
class ConversationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationState = ref.watch(conversationProvider);

    return conversationState.when(
      data: (state) => /* UI */,
      loading: () => /* Loading UI */,
      error: (error, stack) => /* Error UI */,
    );
  }
}
```

### 3. Testing Strategy

```dart
// Unit Test Example
test('should parse conversation log correctly', () {
  // Arrange
  final json = {'id': '1', 'text': 'Hello', 'timestamp': '2024-01-01'};

  // Act
  final result = Conversation.fromJson(json);

  // Assert
  expect(result.id, '1');
  expect(result.text, 'Hello');
});

// Widget Test Example
testWidgets('should display conversation messages', (tester) async {
  // Arrange
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conversationProvider.overrideWith(() => MockConversationProvider()),
      ],
      child: MaterialApp(home: ConversationScreen()),
    ),
  );

  // Assert
  expect(find.text('Hello'), findsOneWidget);
});
```

---

## Critical Implementation Notes

### Bluetooth Audio Streaming

**Challenge**: Flutter doesn't have native Bluetooth Classic audio support

**Solutions**:
1. **Android**: Use platform channels with native Android AudioManager
2. **iOS**: Requires MFi certification OR use BLE Audio (Phase 2)
3. **Fallback**: Start with BLE for MVP, upgrade to Classic HFP later

**Platform Channel Example**:
```dart
// lib/features/conversation/bluetooth/audio_channel.dart
class BluetoothAudioChannel {
  static const platform = MethodChannel('com.yunseul.audio/bluetooth');

  Future<void> startAudioStream() async {
    try {
      await platform.invokeMethod('startAudioStream');
    } on PlatformException catch (e) {
      print("Failed to start audio: '${e.message}'.");
    }
  }
}
```

```kotlin
// android/app/src/main/kotlin/MainActivity.kt
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yunseul.audio/bluetooth"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "startAudioStream") {
                    // Implement native Bluetooth audio streaming
                    result.success(true)
                }
            }
    }
}
```

### Performance Targets

- **Response Latency**: ≤ 1.2 seconds (P95)
  - Bluetooth: ~50ms
  - WebRTC: ~200ms
  - AI Processing: ~800ms
  - Bluetooth: ~50ms

- **Connection Stability**:
  - WebRTC uptime: ≥ 99%
  - Bluetooth reconnection: < 3 seconds
  - Packet loss: ≤ 3%

### Safety & Privacy

**Must Implement**:
- End-to-end encryption for conversation logs
- Parental consent flow (COPPA compliance)
- Forbidden word filtering (10 core keywords)
- Real-time risk detection (GPT-4 sentiment analysis)
- Secure token storage (flutter_secure_storage)

**Data Handling**:
```dart
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

---

## Common Development Tasks

### Adding a New Feature

1. Create feature folder structure:
```bash
lib/features/new_feature/
  ├── data/
  │   ├── datasources/
  │   ├── models/
  │   └── repositories/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/
  │   └── usecases/
  └── presentation/
      ├── providers/
      ├── screens/
      └── widgets/
```

2. Follow TDD approach:
   - Write test first
   - Implement minimum code to pass
   - Refactor

3. Generate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Debugging Bluetooth Issues

```bash
# Enable verbose logging
flutter run --verbose

# Android Bluetooth logs
adb logcat | grep -E "Bluetooth|HFP|Audio"

# Check Bluetooth permissions
adb shell dumpsys bluetooth_manager
```

### Optimizing Build Size

```bash
# Analyze bundle size
flutter build apk --analyze-size

# Build with code shrinking
flutter build apk --shrink --split-per-abi

# Check what's in the APK
unzip -l build/app/outputs/flutter-apk/app-release.apk
```

---

## Environment Configuration

### Development Environments

```dart
// lib/core/config/environment.dart
enum Environment { dev, staging, prod }

class Config {
  static Environment currentEnvironment = Environment.dev;

  static String get apiBaseUrl {
    switch (currentEnvironment) {
      case Environment.dev:
        return 'https://dev-api.yunseul.com';
      case Environment.staging:
        return 'https://staging-api.yunseul.com';
      case Environment.prod:
        return 'https://api.yunseul.com';
    }
  }
}
```

### Running with Different Environments

```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev

# Production
flutter run --dart-define=ENVIRONMENT=prod
flutter build apk --dart-define=ENVIRONMENT=prod
```

---

## MVP Timeline (3 Months)

### Week 1-4: Foundation
- Backend API integration
- Authentication flow
- Bluetooth scanning and pairing UI

### Week 5-8: Core Features
- Bluetooth HFP audio streaming (Platform channels)
- WebRTC integration
- Conversation UI
- Safety filtering implementation

### Week 9-10: Parent Dashboard
- Conversation logs screen
- Risk alert notifications
- Settings and parental controls

### Week 11-12: Testing & Launch
- Beta testing with 5-10 families
- Bug fixes and optimization
- App Store submission

---

## Troubleshooting

### Bluetooth Issues
- **Device not found**: Check Bluetooth permissions in AndroidManifest.xml
- **Audio not streaming**: Verify HFP profile support on device
- **Connection drops**: Implement reconnection logic with exponential backoff

### WebRTC Issues
- **High latency**: Check network conditions, optimize audio codec
- **Connection failed**: Verify TURN/STUN server configuration
- **Echo/feedback**: Implement echo cancellation in audio pipeline

### Build Issues
- **Build fails after dependency update**: Run `flutter clean && flutter pub get`
- **iOS build fails**: Update CocoaPods: `cd ios && pod update && cd ..`
- **Android build fails**: Check Gradle version compatibility

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [WebRTC Flutter Plugin](https://pub.dev/packages/flutter_webrtc)
- [Bluetooth Serial Plugin](https://pub.dev/packages/flutter_bluetooth_serial)
- [ElevenLabs API Docs](https://elevenlabs.io/docs)

---

## Team Communication

- **Daily Standups**: 10 AM KST (in-person or Slack)
- **Sprint Planning**: Every 2 weeks
- **Code Reviews**: Required for all PRs (1+ approval)
- **Bug Reports**: Use GitHub Issues with template
- **Feature Requests**: Discuss in weekly team meeting

---

## Important Notes

### Flutter-Specific Best Practices

1. **Always use `const` constructors** where possible for performance
2. **Avoid rebuilding entire widget trees** - use `Consumer` or `select` with Riverpod
3. **Keep widgets small** - extract complex widgets into separate files
4. **Use `Key` properly** when working with lists
5. **Implement proper error handling** with AsyncValue pattern

### Bluetooth Development

- **Test on real devices only** - Bluetooth doesn't work on emulators
- **Request permissions at runtime** for Android 12+
- **Handle background audio** - use foreground services on Android
- **Consider battery impact** - optimize Bluetooth scanning and connections

### WebRTC Development

- **Test with poor network conditions** - simulate 3G speeds
- **Implement reconnection logic** - handle network switches gracefully
- **Monitor bandwidth usage** - audio streaming can be costly
- **Use TURN servers** - for NAT traversal in production

---

## Contact & Support

- **Technical Lead**: [Contact Info]
- **Product Manager**: [Contact Info]
- **Emergency Contact**: [Contact Info]
- **GitHub Repository**: [Repo URL]
- **Project Management**: Linear / Notion
