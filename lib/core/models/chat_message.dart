import 'package:equatable/equatable.dart';

enum MessageRole { user, ai, system }

class ChatAttachment extends Equatable {
  final String id;
  final String url;
  final String type;
  final String? name;

  const ChatAttachment({
    required this.id,
    required this.url,
    required this.type,
    this.name,
  });

  @override
  List<Object?> get props => [id, url, type, name];
}

class ChatMessage extends Equatable {
  final String id;
  final String text;
  final MessageRole role;
  final DateTime createdAt;
  final List<ChatAttachment>? attachments;
  final Map<String, dynamic>? metadata;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
    this.attachments,
    this.metadata,
    this.isStreaming = false,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        role,
        createdAt,
        attachments,
        metadata,
        isStreaming,
      ];

  ChatMessage copyWith({
    String? id,
    String? text,
    MessageRole? role,
    DateTime? createdAt,
    List<ChatAttachment>? attachments,
    Map<String, dynamic>? metadata,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}
