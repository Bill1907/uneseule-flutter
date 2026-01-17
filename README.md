# Uneseule Flutter App

Voice AI Companion Doll (윤슬) - Flutter 모바일 앱

## Overview

ESP32-S3 기반 음성 AI 인형과 연동되는 Flutter 앱입니다. 아이들(3-10세)이 AI 어시스턴트와 실시간 대화할 수 있도록 지원하며, 부모에게 모니터링 및 안전 기능을 제공합니다.

## Architecture

```
[ESP32-S3 Device] ←→ (BLE Provisioning) ←→ [Flutter App]
                  ←→ (WiFi/Cloud)       ←→ [Backend Server]
                                              ↓
                                       [Parent Dashboard]
```

## Key Features

### Phase 0: BLE Device Provisioning (Current)
- BLE 스캔으로 디바이스 발견
- 디바이스 정보 읽기 (MAC, Battery, Firmware Version, Secret Key)
- WiFi Credentials 전송
- 클라우드 등록

### Phase 1+: Core Features
- 실시간 음성 대화 (WebRTC)
- 부모 대시보드
- 안전 모니터링

## Tech Stack

- **Framework**: Flutter 3.29.2 / Dart 3.7.2
- **State Management**: Riverpod + Freezed
- **BLE**: flutter_blue_plus
- **Navigation**: go_router

## Getting Started

```bash
# Dependencies 설치
flutter pub get

# 코드 생성 (freezed 등)
dart run build_runner build --delete-conflicting-outputs

# 앱 실행 (실제 디바이스 필요 - BLE는 에뮬레이터 미지원)
flutter run
```

## Project Structure

```
lib/
├── core/              # Constants, Theme, Utils
├── features/
│   ├── device_provisioning/  # BLE Setup (Phase 0)
│   ├── conversation/         # Voice Chat (Phase 1+)
│   └── parent_dashboard/     # Parent Features
└── shared/            # Reusable widgets & services
```

## Device Info Model

BLE 연결 후 읽어오는 디바이스 정보:

| Field | Description |
|-------|-------------|
| MAC Address | 디바이스 고유 식별자 |
| Battery Level | 배터리 잔량 (0-100%) |
| Firmware Version | 설치된 펌웨어 버전 |
| Device Secret Key | 클라우드 인증용 키 |

## Requirements

- Flutter 3.29.2+
- iOS 12.0+ / Android 6.0+
- 실제 디바이스 (BLE 테스트용)

## Documentation

자세한 개발 가이드는 [CLAUDE.md](./CLAUDE.md) 참고
