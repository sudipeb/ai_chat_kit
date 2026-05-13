import 'package:ai_chat_kit/core/models/chat_message.dart';
import 'package:ai_chat_kit/domain/entities/ai_model_provider.dart';
import 'package:dio/dio.dart';

class GeminiProvider implements AIModelProvider {
  final String apiKey;
  final String baseUrl;
  final Dio dio;

  GeminiProvider({required this.apiKey, this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta', Dio? dio})
    : dio = dio ?? Dio();

  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    final url = '$baseUrl/models/$model:generateContent?key=$apiKey';

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

    int retryCount = 0;
    const maxRetries = 3;
    Duration retryDelay = const Duration(seconds: 1);

    while (true) {
      try {
        final response = await dio.post(
          url,
          data: {
            'contents': contents,
            'generationConfig': {
              'temperature': options?['temperature'] ?? 0.9,
              'maxOutputTokens': options?['max_tokens'] ?? 2048,
            },
          },
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (response.statusCode == 503 && retryCount < maxRetries) {
          retryCount++;
          await Future.delayed(retryDelay);
          retryDelay *= 2;
          continue;
        }

        if (response.statusCode != 200) {
          throw Exception('Gemini API Error ${response.statusCode}: ${response.data}');
        }

        final data = response.data as Map<String, dynamic>;
        return data['candidates'][0]['content']['parts'][0]['text'] as String;
      } catch (e) {
        if (retryCount >= maxRetries) {
          rethrow;
        }
        rethrow;
      }
    }
  }
}
