import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/chat_message.dart';
import '../../../domain/entities/ai_model_provider.dart';

class GeminiProvider implements AIModelProvider {
  final String apiKey;
  final String baseUrl;

  GeminiProvider({
    required this.apiKey,
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta',
  });

  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    final contents = _buildContents(history, prompt);

    final response = await http.post(
      Uri.parse('$baseUrl/models/$model:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': contents,
        'generationConfig': {
          'temperature': options?['temperature'] ?? 0.9,
          'maxOutputTokens': options?['max_tokens'] ?? 2048,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  List<Map<String, dynamic>> _buildContents(List<ChatMessage> history, String prompt) {
    final contents = <Map<String, dynamic>>[];

    for (final msg in history) {
      contents.add({
        'role': msg.role == MessageRole.user ? 'user' : 'model',
        'parts': [
          {'text': msg.text},
        ],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': prompt},
      ],
    });

    return contents;
  }
}
