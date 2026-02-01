import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

// FirestoreService: операции с пользователями, чатами и сообщениями
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Создать документ пользователя
  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'userId': user.userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Поиск пользователя по userId
  Future<AppUser?> findUserByUserId(String userId) async {
    final snap = await _db.collection('users').where('userId', isEqualTo: userId).get();
    if (snap.docs.isEmpty) return null;
    final d = snap.docs.first.data();
    return AppUser(uid: d['uid'], email: d['email'], userId: d['userId']);
  }

  // Возвращает id чата для пары пользователей — консистентно
  String chatIdFor(String a, String b) {
    final list = [a, b]..sort();
    return '${list[0]}_${list[1]}';
  }

  // Создать чат (если нужно) с двумя участниками
  Future<void> ensureChatExists(String aUid, String bUid) async {
    final chatId = chatIdFor(aUid, bUid);
    final doc = _db.collection('chats').doc(chatId);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'participants': [aUid, bUid],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Stream списка чатов для пользователя
  Stream<QuerySnapshot> chatsFor(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Stream сообщений чата
  Stream<QuerySnapshot> messagesStream(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Отправить сообщение
  Future<void> sendMessage(String chatId, Message msg) async {
    final ref = _db.collection('chats').doc(chatId).collection('messages');
    await ref.add({
      'text': msg.text,
      'senderId': msg.senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
