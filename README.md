# Chaty Agent

A Flutter chat application powered by Google Gemini AI.

## Features

- Real-time chat with Gemini AI
- Clean message bubbles with AI avatar
- Multi-line text input
- Material 3 design

## Tech Stack

- **Flutter** — cross-platform UI
- **Gemini API** — AI responses (`gemini-3.5-flash`)
- **flutter_bloc** — state management (Cubit)
- **get_it** — dependency injection
- **http** — network requests

## Architecture

Follows a strict layered architecture:

```
lib/
├── core/
│   └── result/          # ApiResult sealed class
├── features/
│   └── chat/
│       ├── data/
│       │   ├── models/      # ChatMessageModel
│       │   ├── repositories/ # GeminiChatRepositoryImpl
│       │   └── services/    # GeminiChatService
│       ├── domain/
│       │   ├── entities/    # ChatMessage
│       │   ├── repositories/ # ChatRepository (abstract)
│       │   └── usecases/    # SendMessageUseCase
│       └── presentation/
│           ├── cubit/       # SendMessageCubit + States
│           ├── screens/     # ChatScreen
│           └── widgets/     # MessageBubble, MessageList, ChatInputBar
```

## Getting Started

### Prerequisites

- Flutter SDK `^3.10.4`
- A [Gemini API key](https://aistudio.google.com/app/apikey)

### Setup

1. Clone the repository

```bash
git clone https://github.com/your-username/Chaty_AI_Agent.git
cd Chaty_AI_Agent
```

2. Install dependencies

```bash
flutter pub get
```

3. Add your Gemini API key in the DI setup (`core/di/`)

4. Run the app

```bash
flutter run
```

## State Management

`SendMessageCubit` emits four states:

| State | Description |
|---|---|
| `SendMessageInitial` | Default state |
| `SendMessageLoading` | Request in progress |
| `SendMessageSuccess` | AI reply received |
| `SendMessageFailure` | Error occurred |
