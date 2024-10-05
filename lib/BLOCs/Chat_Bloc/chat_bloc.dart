import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Services/chat_sevice.dart';
import 'chat_events.dart';
import 'chat_states.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;

  ChatBloc(this._chatService) : super(ChatInitial()) {
    on<FetchMessages>(_onFetchMessages);
    on<SendMessage>(_onSendMessage);
    on<UpdateOnlineStatus>(_onUpdateOnlineStatus);
    on<UpdateTypingStatus>(_onUpdateTypingStatus);
  }

  void _onFetchMessages(FetchMessages event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      final messagesStream = _chatService.getMessages();
      await for (var snapshot in messagesStream) {
        List messages = snapshot.docs.map((doc) => doc.data()).toList();
        emit(ChatLoaded(messages));
      }
    } catch (e) {
      emit(ChatError('Failed to load messages'));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await _chatService.sendMessage(event.userId, event.message);
    } catch (e) {
      emit(ChatError('Failed to send message'));
    }
  }

  void _onUpdateOnlineStatus(
      UpdateOnlineStatus event, Emitter<ChatState> emit) async {
    try {
      await _chatService.updateOnlineStatus(event.userId, event.isOnline);
    } catch (e) {
      emit(ChatError('Failed to update online status'));
    }
  }

  void _onUpdateTypingStatus(
      UpdateTypingStatus event, Emitter<ChatState> emit) async {
    try {
      await _chatService.updateTypingStatus(event.userId, event.isTyping);
    } catch (e) {
      emit(ChatError('Failed to update typing status'));
    }
  }
}
