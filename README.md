# Chaty Agent

A Flutter chat application powered by Google Gemini AI, built with clean architecture and production-ready CI/CD.

## Features

- Real-time chat with Gemini AI (`gemini-3.5-flash`)
- Automatic retry on server errors (up to 3 attempts)
- Human-readable error messages for all failure cases
- Dev and Prod flavors with separate bundle IDs
- Automated APK + IPA builds via GitHub Actions
- Build notifications sent to email on every release

## Tech Stack

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management (Cubit) |
| `get_it` | Dependency injection |
| `http` | Network requests |

## Architecture

Strict layered architecture: **presentation → domain → data**

```
lib/
├── core/
│   ├── config/         # AppConfig, Flavor enum
│   ├── di/             # get_it dependency registration
│   ├── error/          # Typed AppException sealed class
│   └── result/         # ApiResult<T> (ApiSuccess / ApiFailure)
│
└── features/
    └── chat/
        ├── data/
        │   ├── models/         # ChatMessageModel (Gemini JSON)
        │   ├── repositories/   # GeminiChatRepositoryImpl
        │   └── services/       # GeminiChatService (HTTP + retry)
        ├── domain/
        │   ├── entities/       # ChatMessage
        │   ├── repositories/   # ChatRepository (abstract)
        │   └── usecases/       # SendMessageUseCase
        └── presentation/
            ├── cubit/          # SendMessageCubit + States
            ├── screens/        # ChatScreen
            └── widgets/        # MessageBubble, MessageList, ChatInputBar
```

## Error Handling

All errors are caught at the data boundary and surfaced as human-readable messages:

| Error | User sees |
|---|---|
| No internet | "No internet connection. Please check your network and try again." |
| Timeout | "The request took too long. Please try again." |
| Rate limited (429) | "You're sending messages too fast. Please wait a moment and try again." |
| Unauthorized (401/403) | "Authentication failed. Please check your API key." |
| Server error (5xx) | "The AI service is having trouble right now. Please try again in a moment." |
| Unknown | "Something went wrong. Please try again." |

Server errors (5xx) are retried automatically up to **3 times** with progressive delay before failing.

## Flavors

| | Dev | Prod |
|---|---|---|
| Bundle ID (Android) | `com.codemind.chatyaiagent.dev` | `com.codemind.chatyaiagent` |
| Bundle ID (iOS) | `com.codemind.chatyaiagent.dev` | `com.codemind.chatyaiagent` |
| App name | Chaty Agent Dev | Chaty Agent |
| Debug banner | Shown | Hidden |

## Getting Started

### Prerequisites

- Flutter SDK `^3.10.4`
- A [Gemini API key](https://aistudio.google.com/app/apikey)

### Setup

1. Clone the repository

```bash
git clone https://github.com/engmostafasoliman/Chaty_AI_-Agent.git
cd Chaty_AI_-Agent
```

2. Install dependencies

```bash
flutter pub get
```

3. Create your env file

```bash
cp .env.example .env.dev
# Add your GEMINI_API_KEY to .env.dev
```

4. Run the app

```bash
# Dev flavor
flutter run --flavor dev --target lib/main_dev.dart --dart-define-from-file=.env.dev

# Prod flavor
flutter run --flavor prod --target lib/main_prod.dart --dart-define-from-file=.env.prod
```

## CI/CD

Builds are triggered automatically by pushing a version tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions will:
1. Build **dev + prod APK** (Android)
2. Build **dev + prod IPA** (iOS)
3. Create a **GitHub Release** with all 4 artifacts
4. Send an **email notification** with the download link

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `GEMINI_API_KEY_DEV` | Gemini API key for dev flavor |
| `GEMINI_API_KEY_PROD` | Gemini API key for prod flavor |
| `IOS_CERTIFICATE_BASE64` | Apple distribution certificate (base64) |
| `IOS_CERTIFICATE_PASSWORD` | Certificate password |
| `IOS_PROFILE_DEV_BASE64` | Dev provisioning profile (base64) |
| `IOS_PROFILE_PROD_BASE64` | Prod provisioning profile (base64) |
| `GMAIL_USERNAME` | Gmail address to send from |
| `GMAIL_APP_PASSWORD` | Gmail app password |

## Testing

```bash
flutter test
```

**20 tests** covering:
- `ChatMessageModel` — fromJson, toJson, text getter, roundtrip
- `GeminiChatRepositoryImpl` — success, all error types with humanized messages
- `SendMessageUseCase` — success, failure, delegation
- `SendMessageCubit` — all 4 states, message content verification

## Cubit States

```
sendMessage() called
  → SendMessageLoading
  → SendMessageSuccess(ChatMessage)   — on success
  → SendMessageFailure(String)        — on error (humanized)
```
