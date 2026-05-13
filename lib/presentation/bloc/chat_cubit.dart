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
    emit(ChatLoading(messages: updatedMessages));

    try {
      final aiMessageId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
      String accumulatedResponse = '';

      final stream = provider.streamMessage(model: model, prompt: text, history: updatedMessages);

      await for (final chunk in stream) {
        accumulatedResponse += chunk;

        final aiMessage = ChatMessage(
          id: aiMessageId,
          text: accumulatedResponse,
          role: MessageRole.ai,
          createdAt: DateTime.now(),
        );

        // Replace or add the AI message in the list
        final messagesWithAi = List<ChatMessage>.from(updatedMessages);
        final existingIndex = messagesWithAi.indexWhere((m) => m.id == aiMessageId);
        if (existingIndex != -1) {
          messagesWithAi[existingIndex] = aiMessage;
        } else {
          messagesWithAi.add(aiMessage);
        }

        _logState('Transition -> ChatStreaming');
        emit(ChatStreaming(messages: messagesWithAi));
      }

      _logState('Transition ChatStreaming -> ChatSuccess');
      emit(ChatSuccess(messages: state.messages));
    } catch (e) {
      _logState('Transition -> ChatError: $e');
      emit(ChatError(error: e.toString(), messages: updatedMessages));
    }
  }

  void _logState(String message) {
    AIChatLogger.log(message);
  }

  /// Clears the chat history.
  void clearChat() {
    _logState('Clearing chat history');
    emit(const ChatInitial());
  }
}
