abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatIsUserOnline extends ChatState {}

class ChatIsOtherUserTyping extends ChatState {}

class ChatLoaded extends ChatState {
  final List messages;

  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}
