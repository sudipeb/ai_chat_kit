// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIConfig _$AIConfigFromJson(Map<String, dynamic> json) => _AIConfig(
  openAiKey: json['openAiKey'] as String,
  geminiKey: json['geminiKey'] as String,
  claudeKey: json['claudeKey'] as String,
);

Map<String, dynamic> _$AIConfigToJson(_AIConfig instance) => <String, dynamic>{
  'openAiKey': instance.openAiKey,
  'geminiKey': instance.geminiKey,
  'claudeKey': instance.claudeKey,
};
