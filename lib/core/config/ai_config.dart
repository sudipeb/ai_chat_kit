import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_config.freezed.dart';
part 'ai_config.g.dart';

@freezed
abstract class AIConfig with _$AIConfig {
  const factory AIConfig({
    required String openAiKey,
    required String geminiKey,
    required String claudeKey,
  }) = _AIConfig;

  const AIConfig._();

  bool get hasOpenAiKey => openAiKey.isNotEmpty;

  bool get hasGeminiKey => geminiKey.isNotEmpty;

  bool get hasClaudeKey => claudeKey.isNotEmpty;

  factory AIConfig.fromJson(Map<String, dynamic> json) => _$AIConfigFromJson(json);
}
