import 'package:ai_chat_kit/core/models/chat_message.dart';
import 'package:ai_chat_kit/domain/entities/ai_model_provider.dart';
import 'package:dio/dio.dart';

class ClaudeProvider implements AIModelProvider {
  final String apiKey;
  final String baseUrl;
  final Dio dio;

  ClaudeProvider({required this.apiKey, this.baseUrl = 'https://api.anthropic.com/v1', Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    final messages = _buildMessages(history, prompt);

    int retryCount = 0;
    const maxRetries = 3;
    Duration retryDelay = const Duration(seconds: 1);

    while (true) {
      try {
        final response = await dio.post(
          '$baseUrl/chat/completions',
          data: {
            'model': model,
            'messages': messages,
            'temperature': options?['temperature'] ?? 0.7,
            'max_tokens': options?['max_tokens'] ?? 1024,
          },
          options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'}),
        );

        if (response.statusCode == 503 && retryCount < maxRetries) {
          retryCount++;
          await Future.delayed(retryDelay);
          retryDelay *= 2;
          continue;
        }

        if (response.statusCode != 200) {
          throw Exception('Claude API Error ${response.statusCode}: ${response.data}');
        }

        final data = response.data as Map<String, dynamic>;
        final message = data['choices']?[0]?['message']?['content'];
        if (message is String) {
          return message;
        }

        final fallback = data['completion'] ?? data['output']?[0]?['content']?[0]?['text'];
        if (fallback is String) {
          return fallback;
        }

        throw Exception('Claude response parsing failed: ${response.data}');
      } catch (e) {
        if (retryCount >= maxRetries) {
          rethrow;
        }
        rethrow;
      }
    }
  }

  List<Map<String, String>> _buildMessages(List<ChatMessage> history, String prompt) {
    final messages = <Map<String, String>>[];

    for (final msg in history) {
      String roleString;
      switch (msg.role) {
        case MessageRole.user:
          roleString = 'user';
          break;
        case MessageRole.ai:
          roleString = 'assistant';
          break;
        case MessageRole.system:
          roleString = 'system';
          break;
      }
      messages.add({'role': roleString, 'content': msg.text});
    }

    messages.add({'role': 'user', 'content': prompt});

    return messages;
  }
}
