# AI Chat Kit

A modular Flutter package designed to provide a unified interface for interacting with multiple AI models (OpenAI, Gemini, Claude, local LLMs, etc.) using a consistent architectural pattern.

## Features

- 🧠 **Multi-model abstraction layer**: Support multiple AI providers through a single, clean API.
- 🔄 **BLoC / Cubit State Management**: Robust and predictable state handling for chat interactions.
- 🎨 **Simplex UI Components**: Reusable, customizable UI components for building chat interfaces quickly.
- 🔑 **Flexible Configuration**: Per-provider API key management and configuration.

## Getting started

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  ai_chat_kit:
    path: ./path/to/ai_chat_kit
  flutter_bloc: ^9.0.0
  get_it: ^8.0.3
```

## Example

An example app demonstrating how to use the `ai_chat_kit` package can be found in the `example` directory. To run it:

1. Navigate to the `example` directory:
   ```bash
   cd example
   ```
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

Create a provider by implementing the `AIModelProvider` interface:

```dart
import 'package:ai_chat_kit/ai_chat_kit.dart';

class MyAIProvider implements AIModelProvider {
  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    // Implement your API call logic here
    // Use the 'model' parameter to specify which model to use for this call
    return "This is a response from the AI.";
  }
}
```

### 2. Using the Chat UI

The package provides `SimplexBlocView` and `SimplexChatView` for building chat pages:

```dart
import 'package:flutter/material.dart';
import 'package:ai_chat_kit/ai_chat_kit.dart';

class MyChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        provider: MyAIProvider(),
        model: 'gpt-4',
      ),
      child: const ChatPage(),
    );
  }
}
```

## Architecture

The package follows a clean architecture pattern:
- **Core**: Models (`ChatMessage`) and configuration.
- **Domain**: Entities and repository interfaces (`AIModelProvider`).
- **Presentation**: BLoC/Cubit for state management and reusable widgets.

## Components

### SimplexBlocView
A base class for BLoC-integrated views that simplifies the boilerplate of using `BlocBuilder`. Override `buildWidget` to define your UI.

### SimplexChatView
A standard chat interface component including a message list (with bubble styling) and a message input field.

## Additional information

For more detailed information on adding new providers or customizing the UI, refer to the `GEMINI.MD` file in the project root.
