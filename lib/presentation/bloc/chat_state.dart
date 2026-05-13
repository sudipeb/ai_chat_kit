import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/models/chat_message.dart';

part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState.initial({@Default([]) List<ChatMessage> messages}) = ChatInitial;

  const factory ChatState.loading({@Default([]) List<ChatMessage> messages}) = ChatLoading;

  const factory ChatState.streaming({@Default([]) List<ChatMessage> messages}) = ChatStreaming;

  const factory ChatState.success({@Default([]) List<ChatMessage> messages}) = ChatSuccess;

  const factory ChatState.error({required String error, @Default([]) List<ChatMessage> messages}) = ChatError;
}
