library;

// Simple one-line initialization
export 'ai_chat.dart';

// Core components
export 'core/logger/ai_chat_logger.dart';
export 'core/models/chat_message.dart';
export 'core/config/ai_config.dart';
export 'domain/entities/ai_model_provider.dart';

// Advanced usage (Cubit, State Management, UI)
export 'presentation/bloc/chat_cubit.dart';
export 'presentation/bloc/chat_state.dart';
export 'presentation/pages/chat_page.dart';
export 'presentation/widgets/simplex_widgets.dart';

// Provider implementations (for custom usage)
export 'data/datasources/openai/openai_provider.dart';
export 'data/datasources/gemini/gemini_provider.dart';
export 'data/datasources/claude/claude_provider.dart';
