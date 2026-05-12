import 'package:equatable/equatable.dart';
import '../../core/models/chat_message.dart';

/// Base class for all possible states of the chat cubit.
abstract class ChatState extends Equatable {
  /// The current list of messages in the chat conversation.
  final List<ChatMessage> messages;

  const ChatState(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// Initial state when the chat is created.
class ChatInitial extends ChatState {
  const ChatInitial() : super(const []);
}

/// State indicating that a message is being processed.
class ChatLoading extends ChatState {
  const ChatLoading(super.messages);
}

/// State indicating that the message was processed successfully.
class ChatSuccess extends ChatState {
  const ChatSuccess(super.messages);
}

/// State indicating an error occurred during message processing.
class ChatError extends ChatState {
  /// The error message.
  final String error;

  const ChatError(this.error, super.messages);

  @override
  List<Object?> get props => [error, messages];
}
