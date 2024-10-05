abstract class ChatEvent {}

class FetchMessages extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;
  final String userId;

  SendMessage(this.message, this.userId);
}

class UpdateOnlineStatus extends ChatEvent {
  final String userId;
  final bool isOnline;

  UpdateOnlineStatus(this.userId, this.isOnline);
}

class UpdateOtherUserTypingStatus extends ChatEvent {
  final String userId;
  final bool isTyping;

  UpdateOtherUserTypingStatus(this.userId, this.isTyping);
}

class UpdateTypingStatus extends ChatEvent {
  final String userId;
  final bool isTyping;

  UpdateTypingStatus(this.userId, this.isTyping);
}
