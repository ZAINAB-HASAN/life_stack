import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String generateChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join("_");
  }

  Future<void> sendMessage({
    required String chatId,
    required String message,
    required String senderId,
    required String receiverId,
  }) async {
    final msgData = {
      "text": message,
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": FieldValue.serverTimestamp(),
      "seen": false,
    };

    await firestore
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .add(msgData);

    await firestore.collection("chat_rooms").doc(chatId).set({
      "participants": [senderId, receiverId],
      "lastMessage": message,
      "lastSender": senderId,
      "lastTime": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}