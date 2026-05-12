import 'package:ai_chat_kit/core/models/chat_message.dart';
import 'package:ai_chat_kit/domain/entities/ai_model_provider.dart';
import 'package:dio/dio.dart';

class OpenAIProvider implements AIModelProvider {
  final String apiKey;
  final String baseUrl;
  final Dio dio;

  OpenAIProvider({required this.apiKey, this.baseUrl = 'https://api.openai.com/v1', Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    final messages = _buildMessages(history, prompt);

    final response = await dio.post(
      '$baseUrl/messages',
      data: {
        'model': model,
        'messages': messages,
        'temperature': options?['temperature'] ?? 0.7,
        'max_tokens': options?['max_tokens'] ?? 1024,
      },
      options: Options(
        headers: {'Content-Type': 'application/json', 'x-api-key': apiKey, 'anthropic-version': '2023-06-01'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    return data['content'][0]['text'] as String;
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
