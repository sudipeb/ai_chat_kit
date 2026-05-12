import 'package:flutter/material.dart';
import '../bloc/chat_cubit.dart';
import '../bloc/chat_state.dart';
import '../widgets/simplex_widgets.dart';

class ChatPage extends SimplexBlocView<ChatCubit, ChatState> {
  const ChatPage({super.key});

  @override
  Widget buildWidget(BuildContext context, ChatCubit cubit, ChatState state) {
    return SimplexChatView(
        messages: state.messages,
        onSend: cubit.sendMessage,
        isLoading: state is ChatLoading);
  }
}
