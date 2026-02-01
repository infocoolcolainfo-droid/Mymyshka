import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;

  void _search() async {
    setState(() => _loading = true);
    try {
      final user = await FirestoreService().findUserByUserId(_ctrl.text.trim());
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      } else {
        final myUid = Provider.of<AuthService>(context, listen: false).currentUser!.uid;
        final chatId = FirestoreService().chatIdFor(myUid, user.uid);
        await FirestoreService().ensureChatExists(myUid, user.uid);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chatId: chatId, otherUid: user.uid)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search by userID')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _ctrl, decoration: InputDecoration(labelText: 'userID')),
            SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _search, child: _loading ? CircularProgressIndicator() : Text('Search'))
          ],
        ),
      ),
    );
  }
}
