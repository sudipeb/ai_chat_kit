import 'package:flutter_test/flutter_test.dart';
import 'package:ai_chat_kit/ai_chat_kit.dart';

void main() {
  group('ChatMessage', () {
    test('should create a ChatMessage correctly', () {
      final now = DateTime.now();
      final message = ChatMessage(
        id: '1',
        text: 'Hello',
        role: MessageRole.user,
        createdAt: now,
      );

      expect(message.id, '1');
      expect(message.text, 'Hello');
      expect(message.role, MessageRole.user);
      expect(message.createdAt, now);
    });

    test('should support copyWith', () {
      final now = DateTime.now();
      final message = ChatMessage(
        id: '1',
        text: 'Hello',
        role: MessageRole.user,
        createdAt: now,
      );

      final updatedMessage = message.copyWith(text: 'Updated');

      expect(updatedMessage.text, 'Updated');
      expect(updatedMessage.id, message.id);
    });
  });
}
  