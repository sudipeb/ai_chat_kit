class AIConfig {
  final String openAiKey;
  final String geminiKey;
  final String claudeKey;

  const AIConfig({
    required this.openAiKey,
    required this.geminiKey,
    required this.claudeKey,
  });

  bool get hasOpenAiKey => openAiKey.isNotEmpty;
  bool get hasGeminiKey => geminiKey.isNotEmpty;
  bool get hasClaudeKey => claudeKey.isNotEmpty;
}
