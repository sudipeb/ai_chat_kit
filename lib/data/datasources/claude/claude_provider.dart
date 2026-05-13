import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
          '$baseUrl/messages',
          data: {
            'model': model,
            'messages': messages,
            'max_tokens': options?['max_tokens'] ?? 1024,
            'temperature': options?['temperature'] ?? 0.7,
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          }),
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
        final content = data['content'] as List?;
        if (content != null && content.isNotEmpty) {
          return content[0]['text'] as String;
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

  @override
  Stream<String> streamMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async* {
    final messages = _buildMessages(history, prompt);

    final response = await dio.post(
      '$baseUrl/messages',
      data: {
        'model': model,
        'messages': messages,
        'max_tokens': options?['max_tokens'] ?? 1024,
        'temperature': options?['temperature'] ?? 0.7,
        'stream': true,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        responseType: ResponseType.stream,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API Error ${response.statusCode}');
    }

    final responseBody = response.data as ResponseBody;
    String currentEvent = '';

    await for (final chunk in responseBody.stream.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter())) {
      if (chunk.trim().isEmpty) continue;

      if (chunk.startsWith('event: ')) {
        currentEvent = chunk.substring(7).trim();
        continue;
      }

      if (chunk.startsWith('data: ')) {
        final data = chunk.substring(6).trim();
        if (currentEvent == 'content_block_delta') {
          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final delta = json['delta']?['text'];
            if (delta is String) {
              yield delta;
            }
          } catch (_) {}
        } else if (currentEvent == 'message_stop') {
          break;
        }
      }
    }
  }

  List<Map<String, String>> _buildMessages(List<ChatMessage> history, String prompt) {
    final messages = <Map<String, String>>[];

    for (final msg in history) {
      if (msg.role == MessageRole.system) continue; // Claude handles system differently, usually a separate param

      String roleString;
      switch (msg.role) {
        case MessageRole.user:
          roleString = 'user';
          break;
        case MessageRole.ai:
          roleString = 'assistant';
          break;
        default:
          roleString = 'user';
      }
      messages.add({'role': roleString, 'content': msg.text});
    }

    messages.add({'role': 'user', 'content': prompt});

    return messages;
  }
}
