import 'package:ai_chat_kit/core/models/chat_message.dart';

abstract class AIModelProvider {
  Future<String> sendMessage({
    required String model,
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  });
}
