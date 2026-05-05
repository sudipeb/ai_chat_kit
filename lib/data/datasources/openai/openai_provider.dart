import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/chat_message.dart';
import '../../../domain/entities/ai_model_provider.dart';

class OpenAIProvider implements AIModelProvider {
  final String apiKey;
  final String model;
  final String baseUrl;

  OpenAIProvider({
    required this.apiKey,
    this.model = 'gpt-4',
    this.baseUrl = 'https://api.openai.com/v1',
  });

  @override
  String get modelName => model;

  @override
  Future<String> sendMessage({
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    final messages = _buildMessages(history, prompt);

    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': options?['temperature'] ?? 0.7,
        'max_tokens': options?['max_tokens'] ?? 2048,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'] as String;
  }

  List<Map<String, String>> _buildMessages(
    List<ChatMessage> history,
    String prompt,
  ) {
    final messages = <Map<String, String>>[];

    for (final msg in history) {
      messages.add({
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.text,
      });
    }

    messages.add({'role': 'user', 'content': prompt});

    return messages;
  }
}
