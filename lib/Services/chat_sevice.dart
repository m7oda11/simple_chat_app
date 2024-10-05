import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message to Firestore
  Future<void> sendMessage(String userId, String message) async {
    print(_firestore.collection('messages').snapshots());
    await _firestore.collection('messages').add({
      'sender': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch messages from Firestore in real-time
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Update online status of the user
  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    await _firestore.collection('user_status').doc(userId).set({
      'isOnline': isOnline,
      'lastSeen': isOnline
          ? FieldValue.serverTimestamp()
          : FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Update typing status of the user
  Future<void> updateTypingStatus(String userId, bool isTyping) async {
    await _firestore.collection('user_status').doc(userId).set({
      'isTyping': isTyping,
    }, SetOptions(merge: true));
  }

  // Fetch user status (online and typing indicators)
  Stream<DocumentSnapshot> getUserStatus(String userId) {
    return _firestore.collection('user_status').doc(userId).snapshots();
  }
}
