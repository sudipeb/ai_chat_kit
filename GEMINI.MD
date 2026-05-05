📦 Overview

The AI Chat Kit is a modular Flutter/Dart package designed to provide a unified interface for interacting with multiple AI models (OpenAI, Gemini, Claude, local LLMs, etc.) using API keys.

It uses:

🧠 Multi-model abstraction layer
🔑 API key-based authentication per provider
🔄 BLoC / Cubit for state management
🎨 simplex package for UI + BlocBase foundation
👉 https://github.com/basnetjiten/simplex.git
🎯 Goals
Support multiple LLM providers through a single API
Provide pluggable architecture for adding new models
Maintain clean separation between:
UI
State management
API services
Enable easy embedding into Flutter apps
Provide reusable chat UI components via simplex
🧱 High-Level Architecture
ai_chat_kit/
│
├── lib/
│   ├── core/
│   │   ├── config/
│   │   ├── exceptions/
│   │   ├── models/
│   │   ├── utils/
│   │
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── openai/
│   │   │   ├── gemini/
│   │   │   ├── claude/
│   │   │   └── local_llm/
│   │   ├── repositories/
│   │
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   ├── usecases/
│   │
│   ├── presentation/
│   │   ├── bloc/ (Cubit/BLoC)
│   │   ├── pages/
│   │   ├── widgets/ (using simplex UI)
│   │
│   └── ai_chat_kit.dart
🧠 Multi-Model Support Strategy

Each AI provider implements a common interface:

abstract class AIModelProvider {
  Future<String> sendMessage({
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  });

  String get modelName;
}
Supported Providers
OpenAI GPT (GPT-4, GPT-5, etc.)
Google Gemini
Anthropic Claude
Local LLMs (Ollama / LM Studio)
Custom REST API models
🔑 API Key Management

Each provider requires its own API key:

class AIConfig {
  final String openAiKey;
  final String geminiKey;
  final String claudeKey;

  AIConfig({
    required this.openAiKey,
    required this.geminiKey,
    required this.claudeKey,
  });
}

Keys can be:

Passed at runtime
Loaded from .env
Injected via dependency injection
🔄 State Management (BLoC / Cubit)

We use Cubit (from BLoC package) for simplicity and performance.

Chat Cubit Structure
class ChatCubit extends Cubit<ChatState> {
  final AIModelProvider provider;

  ChatCubit(this.provider) : super(ChatInitial());

  Future<void> sendMessage(String message) async {
    emit(ChatLoading());

    try {
      final response = await provider.sendMessage(
        prompt: message,
        history: state.messages,
      );

      emit(ChatSuccess(updatedMessages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
📊 State Model
abstract class ChatState {
  final List<ChatMessage> messages;

  ChatState(this.messages);
}

class ChatInitial extends ChatState {
  ChatInitial() : super([]);
}

class ChatLoading extends ChatState {
  ChatLoading(List<ChatMessage> messages) : super(messages);
}

class ChatSuccess extends ChatState {
  ChatSuccess(List<ChatMessage> messages) : super(messages);
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error, List<ChatMessage> messages) : super(messages);
}
🎨 UI Layer (Bundled Simplex Components)

We have bundled the essential simplex-style components directly into the package to avoid external Git dependencies.

Key components:
- `SimplexBlocView`: A base class that integrates with `BlocBuilder`. Override `buildWidget` to implement the UI.
- `SimplexChatView`: A standard, ready-to-use chat interface with message bubbles and input handling.

Example usage:

```dart
class ChatPage extends SimplexBlocView<ChatCubit, ChatState> {
  @override
  Widget buildWidget(BuildContext context, ChatCubit cubit, ChatState state) {
    return SimplexChatView(
      messages: state.messages,
      onSend: cubit.sendMessage,
      isLoading: state is ChatLoading,
    );
  }
}
```
🔌 Adding a New AI Provider

Steps:

Implement AIModelProvider
Add API client in data/datasources
Register in repository layer
Inject into Cubit

Example:

class MyCustomAIProvider implements AIModelProvider {
  @override
  Future<String> sendMessage({...}) async {
    // API call logic
  }

  @override
  String get modelName => "custom-ai";
}
🧩 Dependency Injection

Recommended using:

get_it OR
riverpod (optional alternative)

Example:

getIt.registerSingleton<AIModelProvider>(
  OpenAIProvider(apiKey: config.openAiKey),
);
🚀 Package Features
Multi-LLM support
Unified chat interface
Streaming responses (optional extension)
Message history persistence
Typing indicators
Token usage tracking (future scope)
Plugin-based architecture.

## 📱 Example App

A complete demonstration of the package can be found in the `example/` directory. It includes:
- A `MockAIProvider` for testing without API keys.
- Integration of `ChatCubit` and `ChatPage`.
- Basic styling and interaction patterns.