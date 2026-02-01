import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'search_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final uid = auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(onPressed: () => auth.signOut(), icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().chatsFor(uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return Center(child: Text('No chats yet'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index];
              final participants = List<String>.from(d['participants']);
              final other = participants.firstWhere((p) => p != uid);
              return ListTile(
                title: Text('Chat with $other'),
                subtitle: Text(d.id),
                onTap: () async {
                  final chatId = d.id;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chatId: chatId, otherUid: other)));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
        child: Icon(Icons.search),
      ),
    );
  }
}
