import '../../core/models/chat_message.dart';

/// Defines a common interface for AI model providers.
abstract class AIModelProvider {
  /// Sends a prompt to the AI model and returns the response.
  /// 
  /// [model] is the specific identifier for the model to use.
  /// [prompt] is the message to send.
  /// [history] is the list of previous chat messages.
  /// [options] is an optional map of provider-specific parameters.
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  });
}
