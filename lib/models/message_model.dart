import 'package:cloud_firestore/cloud_firestore.dart';

// Модель сообщения
class Message {
  final String text;
  final String senderId;
  final Timestamp? timestamp;

  Message({required this.text, required this.senderId, this.timestamp});
}
