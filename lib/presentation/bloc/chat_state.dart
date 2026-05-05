import 'package:equatable/equatable.dart';
import '../../core/models/chat_message.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> messages;

  const ChatState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatInitial extends ChatState {
  const ChatInitial() : super(const []);
}

class ChatLoading extends ChatState {
  const ChatLoading(super.messages);
}

class ChatSuccess extends ChatState {
  const ChatSuccess(super.messages);
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error, super.messages);

  @override
  List<Object?> get props => [error, messages];
}
