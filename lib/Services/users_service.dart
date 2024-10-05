import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    await _firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
    });
  }

  Future<void> updateTypingStatus(String userId, bool isTyping) async {
    await _firestore.collection('users').doc(userId).update({
      'isTyping': isTyping,
    });
  }

  Stream<DocumentSnapshot> getUserStatus(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }
}
