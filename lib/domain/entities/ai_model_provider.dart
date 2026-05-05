import '../../core/models/chat_message.dart';

abstract class AIModelProvider {
  Future<String> sendMessage({
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  });

  String get modelName;
}
