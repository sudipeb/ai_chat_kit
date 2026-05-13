import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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

    final contents = _buildContents(history, prompt);

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

  @override
  Stream<String> streamMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async* {
    final url = '$baseUrl/models/$model:streamGenerateContent?alt=sse&key=$apiKey';

    final contents = _buildContents(history, prompt);

    final response = await dio.post(
      url,
      data: {
        'contents': contents,
        'generationConfig': {
          'temperature': options?['temperature'] ?? 0.9,
          'maxOutputTokens': options?['max_tokens'] ?? 2048,
        },
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API Error ${response.statusCode}');
    }

    final responseBody = response.data as ResponseBody;
    await for (final chunk in responseBody.stream.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter())) {
      if (chunk.trim().isEmpty) continue;
      if (chunk.startsWith('data: ')) {
        final data = chunk.substring(6).trim();
        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final text = json['candidates']?[0]?['content']?['parts']?[0]?['text'];
          if (text is String) {
            yield text;
          }
        } catch (_) {
          // Ignore parse errors for partial chunks
        }
      }
    }
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
