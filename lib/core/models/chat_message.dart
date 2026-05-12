import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// The role of the sender in a chat conversation.
enum MessageRole { user, ai, system }

/// Represents an optional file or data attachment to a chat message.
@freezed
abstract class ChatAttachment with _$ChatAttachment {
  const factory ChatAttachment({required String id, required String url, required String type, String? name}) =
      _ChatAttachment;

  factory ChatAttachment.fromJson(Map<String, dynamic> json) => _$ChatAttachmentFromJson(json);
}

/// Represents a single message in a chat conversation.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required MessageRole role,
    required DateTime createdAt,
    List<ChatAttachment>? attachments,
    Map<String, dynamic>? metadata,
    @Default(false) bool isStreaming,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
