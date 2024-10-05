import 'dart:ui';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../BLOCs/Chat_Bloc/chat_bloc.dart';
import '../BLOCs/Chat_Bloc/chat_events.dart';
import '../BLOCs/Chat_Bloc/chat_states.dart'; // For timestamp formatting

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  bool _isUserOnline = false;
  String otherUserId = "Friend Name";
  String currentUserId = "";

  @override
  void initState() {
    super.initState();

    currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the chat document where the current user is a participant
    context.read<ChatBloc>().add(FetchMessages());
    FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var participants = doc['participants'];
        otherUserId = participants.firstWhere((id) => id != currentUserId);

        print('Found otherUserId: $otherUserId');

        // Now listen to typing and online status from the chat document
        FirebaseFirestore.instance
            .collection('chats')
            .doc(doc.id)
            .snapshots()
            .listen((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            var typingStatus = snapshot['typingStatus'] ?? {};
            var onlineStatus = snapshot['onlineStatus'] ?? {};

            setState(() {
              _isTyping = typingStatus[otherUserId] ?? false;
              _isUserOnline = onlineStatus[otherUserId] ?? false;
            });
          }
        });
      }
    }).catchError((error) {
      // Handle errors gracefully here
      print('Error fetching chats: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ChatLoaded) {
                      return ListView.builder(
                        padding: EdgeInsets.only(
                            top: MediaQuery.sizeOf(context).height * 0.1),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          var message = state.messages[index];
                          bool isMe = message['sender'] == currentUserId;
                          return chatBubble(
                            message['message'],
                            isMe,
                            message[
                                'timestamp'], // Pass the Firestore timestamp
                          );
                        },
                      );
                    }
                    if (state is ChatError) {
                      return Center(child: Text(state.error));
                    }
                    return Center(child: Text('No messages yet.'));
                  },
                ),
              ),
              // Typing indicator
              if (_isTyping)
                Padding(padding: EdgeInsets.all(8), child: Text('Typing...')),
              // Input field for new messages
              _buildMessageInput(),
            ],
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.1,
              color: Color.lerp(Colors.black12, Color(0xff8f47fe), 0.3),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
              width: double.infinity,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white.withOpacity(0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Color.lerp(
                                  Colors.white, Color(0xff8f47fe), 0.7),
                            )),
                        BlocBuilder<ChatBloc, ChatState>(
                            builder: (context, state) {
                          if (state is ChatIsUserOnline) {
                            return Column(
                              children: [
                                Text(
                                  otherUserId,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Online',
                                  style: TextStyle(color: Colors.white38),
                                )
                              ],
                            );
                          } else if (state is ChatIsOtherUserTyping) {
                            return Column(
                              children: [
                                Text(
                                  otherUserId,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Typing...',
                                  style: TextStyle(color: Colors.white38),
                                )
                              ],
                            );
                          } else {
                            return Text(
                              otherUserId,
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          }
                        }),
                        CircleAvatar()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Color(0xff1b1a1f),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 30, top: 10, right: 15, left: 10),
              child: TextField(
                controller: _messageController,
                onChanged: (text) {
                  // setState(() {
                  //   _isTyping = text.isNotEmpty;
                  // });
                  // context
                  //     .read<ChatBloc>()
                  //     .add(UpdateTypingStatus(widget.userId, _isTyping));
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)),
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: CircleAvatar(
              backgroundColor: const Color(0xff8f47fe),
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      context.read<ChatBloc>().add(SendMessage(
                            _messageController.text,
                            currentUserId,
                          ));
                      _messageController.clear();
                      // setState(() {
                      //   _isTyping = false;
                      // });
                      // context
                      //     .read<ChatBloc>()
                      //     .add(UpdateTypingStatus(currentUserId, false));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BubbleSpecialThree chatBubble(
      String message, bool isMe, Timestamp? timestamp) {
    // Format the timestamp to a readable format
    Timestamp usedTimestamp = timestamp ?? Timestamp.now();
    String formattedTime = DateFormat('hh:mm a').format(usedTimestamp.toDate());

    return BubbleSpecialThree(
      isSender: isMe,
      text: message,
      sent: true,
      color: isMe ? const Color(0xff8f47fe) : const Color(0xff31252b),
      tail: true,
      textStyle: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
