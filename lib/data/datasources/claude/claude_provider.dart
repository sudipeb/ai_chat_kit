import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/chat_message.dart';
import '../../../domain/entities/ai_model_provider.dart';

class ClaudeProvider implements AIModelProvider {
  final String apiKey;
  final String baseUrl;

  ClaudeProvider({
    required this.apiKey,
    this.baseUrl = 'https://api.anthropic.com/v1',
  });

  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    final messages = _buildMessages(history, prompt);

    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': options?['temperature'] ?? 0.7,
        'max_tokens': options?['max_tokens'] ?? 1024,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['content'][0]['text'] as String;
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
