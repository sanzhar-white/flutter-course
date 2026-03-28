import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _messagesCollection = 'messages';

  /// Отправить сообщение в чат
  Future<void> sendMessage({
    required String text,
    required String senderEmail,
  }) async {
    await _firestore.collection(_messagesCollection).add({
      'text': text.trim(),
      'sender': senderEmail,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Получить поток сообщений (упорядочены по времени)
  Stream<QuerySnapshot> getMessagesStream() {
    return _firestore
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Получить поток сообщений (последние сверху для reverse ListView)
  Stream<QuerySnapshot> getMessagesStreamDescending() {
    return _firestore
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Удалить сообщение
  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection(_messagesCollection).doc(messageId).delete();
  }
}
