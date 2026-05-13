import 'package:ai_chat_kit/ai_chat_kit.dart';

/// A mock AI provider for demonstration purposes.
class MockAIProvider implements AIModelProvider {
  @override
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (prompt.toLowerCase().contains('hello')) {
      return 'Hello! I am a mock AI (Model: $model). How can I help you today?';
    } else if (prompt.toLowerCase().contains('who are you')) {
      return 'I am the AI Chat Kit demo provider.';
    } else {
      return 'You said: "$prompt" to model "$model". This is a response from the mock AI.';
    }
  }

  @override
  Stream<String> streamMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async* {
    // Simulate network delay for the start of the stream
    await Future.delayed(const Duration(milliseconds: 500));

    final String response;
    if (prompt.toLowerCase().contains('hello')) {
      response = 'Hello! I am a mock AI (Model: $model). How can I help you today?';
    } else if (prompt.toLowerCase().contains('who are you')) {
      response = 'I am the AI Chat Kit demo provider.';
    } else {
      response = 'You said: "$prompt" to model "$model". This is a response from the mock AI.';
    }

    // Split the response into words and stream them with small delays
    final words = response.split(' ');
    for (var i = 0; i < words.length; i++) {
      yield '${words[i]}${i == words.length - 1 ? '' : ' '}';
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
