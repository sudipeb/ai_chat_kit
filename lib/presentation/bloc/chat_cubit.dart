import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/chat_message.dart';
import '../../domain/entities/ai_model_provider.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final AIModelProvider provider;

  ChatCubit(this.provider) : super(const ChatInitial());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMessage);
    emit(ChatLoading(updatedMessages));

    try {
      final responseText = await provider.sendMessage(
        prompt: text,
        history: state.messages,
      );

      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: responseText,
        role: MessageRole.ai,
        createdAt: DateTime.now(),
      );

      emit(ChatSuccess(List<ChatMessage>.from(updatedMessages)..add(aiMessage)));
    } catch (e) {
      emit(ChatError(e.toString(), updatedMessages));
    }
  }
}
