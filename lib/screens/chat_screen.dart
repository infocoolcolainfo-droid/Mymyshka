import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUid;
  ChatScreen({required this.chatId, required this.otherUid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  bool _sending = false;

  void _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    final myUid = Provider.of<AuthService>(context, listen: false).currentUser!.uid;
    final msg = Message(text: text, senderId: myUid);
    await FirestoreService().sendMessage(widget.chatId, msg);
    _ctrl.clear();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final myUid = Provider.of<AuthService>(context).currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().messagesStream(widget.chatId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                final docs = snap.data?.docs ?? [];
                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i];
                    final text = d['text'] ?? '';
                    final sender = d['senderId'] ?? '';
                    final ts = d['timestamp'] as Timestamp?;
                    // AnimatedSwitcher per message for smooth appearance
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SizeTransition(sizeFactor: animation, axisAlignment: 0.0, child: child)),
                      child: MessageBubble(key: ValueKey(d.id), text: text, isMe: sender == myUid, timestamp: ts?.toDate()),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 120),
                        child: Scrollbar(
                          child: TextField(
                            controller: _ctrl,
                            decoration: InputDecoration(border: InputBorder.none, hintText: 'Message', isDense: true),
                            minLines: 1,
                            maxLines: 5,
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Larger circular send button for better tapping on mobile
                  Container(
                    width: 56,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(0)),
                      onPressed: _sending ? null : _send,
                      child: _sending ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(Icons.send, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
