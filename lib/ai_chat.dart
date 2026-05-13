import 'package:ai_chat_kit/core/models/chat_message.dart';
import 'package:ai_chat_kit/data/datasources/claude/claude_provider.dart';
import 'package:ai_chat_kit/data/datasources/gemini/gemini_provider.dart';
import 'package:ai_chat_kit/data/datasources/openai/openai_provider.dart';
import 'package:ai_chat_kit/domain/entities/ai_model_provider.dart';
import 'package:dio/dio.dart';

/// Enum for supported AI providers
enum AIProvider { openai, gemini, claude }

/// Simple, one-line initialization for AI chat
/// 
/// Usage:
/// ```dart
/// final chat = AIChat(token: 'your-api-token');
/// final response = await chat.send('Hello!');
/// ```
class AIChat {
  late final AIModelProvider _provider;
  late final String _model;
  final List<ChatMessage> _history = [];

  /// Initialize AIChat with just a token
  /// 
  /// [token] - Your API token
  /// [provider] - Provider type (openai, gemini, claude). Auto-detected if not provided
  /// [model] - Model name. Defaults to recommended model for each provider
  /// [dio] - Optional Dio instance for custom HTTP configuration
  AIChat({
    required String token,
    AIProvider? provider,
    String? model,
    Dio? dio,
  }) {
    final detectedProvider = provider ?? _autoDetectProvider(token);
    final dioInstance = dio ?? Dio();

    switch (detectedProvider) {
      case AIProvider.openai:
        _model = model ?? 'gpt-4o';
        _provider = OpenAIProvider(apiKey: token, dio: dioInstance);
        break;
      case AIProvider.gemini:
        _model = model ?? 'gemini-1.5-flash';
        _provider = GeminiProvider(apiKey: token, dio: dioInstance);
        break;
      case AIProvider.claude:
        _model = model ?? 'claude-3-5-sonnet-20241022';
        _provider = ClaudeProvider(apiKey: token, dio: dioInstance);
        break;
    }
  }

  /// Send a message and get a response
  /// 
  /// [message] - The message to send
  /// [options] - Optional parameters (temperature, max_tokens, etc.)
  Future<String> send(
    String message, {
    Map<String, dynamic>? options,
  }) async {
    final response = await _provider.sendMessage(
      model: _model,
      prompt: message,
      history: _history,
      options: options,
    );

    // Add to history
    _history.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    ));

    _history.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: response,
      role: MessageRole.ai,
      createdAt: DateTime.now(),
    ));

    return response;
  }

  /// Clear conversation history
  void clearHistory() => _history.clear();

  /// Get conversation history
  List<ChatMessage> getHistory() => List.unmodifiable(_history);

  /// Auto-detect provider based on token format
  static AIProvider _autoDetectProvider(String token) {
    if (token.startsWith('sk-')) {
      return AIProvider.openai;
    } else if (token.startsWith('AIza')) {
      return AIProvider.gemini;
    } else if (token.contains('-claude-') || token.length > 20) {
      return AIProvider.claude;
    }
    // Default to OpenAI for generic tokens
    return AIProvider.openai;
  }
}
