// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatAttachment _$ChatAttachmentFromJson(Map<String, dynamic> json) =>
    _ChatAttachment(
      id: json['id'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ChatAttachmentToJson(_ChatAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': instance.type,
      'name': instance.name,
    };

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  text: json['text'] as String,
  role: $enumDecode(_$MessageRoleEnumMap, json['role']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => ChatAttachment.fromJson(e as Map<String, dynamic>))
      .toList(),
  metadata: json['metadata'] as Map<String, dynamic>?,
  isStreaming: json['isStreaming'] as bool? ?? false,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'isStreaming': instance.isStreaming,
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.ai: 'ai',
  MessageRole.system: 'system',
};
