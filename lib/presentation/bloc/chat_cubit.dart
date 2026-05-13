import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/logger/ai_chat_logger.dart';
import '../../core/models/chat_message.dart';
import '../../domain/entities/ai_model_provider.dart';
import 'chat_state.dart';

/// Manages the state and business logic of a chat conversation.
class ChatCubit extends Cubit<ChatState> {
  final AIModelProvider provider;
  final String model;

  /// Initializes the cubit with the given [provider] and [model].
  ChatCubit({required this.provider, required this.model}) : super(const ChatInitial());

  /// Sends a text message to the AI and manages the chat state.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMessage);
    _logState('Transition ${state.runtimeType} -> ChatLoading');
    emit(ChatLoading(updatedMessages));

    try {
      final responseText = await provider.sendMessage(model: model, prompt: text, history: updatedMessages);

      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: responseText,
        role: MessageRole.ai,
        createdAt: DateTime.now(),
      );

      _logState('Transition ChatLoading -> ChatSuccess');
      emit(ChatSuccess(List<ChatMessage>.from(updatedMessages)..add(aiMessage)));
    } catch (e) {
      _logState('Transition ChatLoading -> ChatError: $e');
      emit(ChatError(e.toString(), updatedMessages));
    }
  }

  void _logState(String message) {
    AIChatLogger.log(message);
  }
}
