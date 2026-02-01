import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  void _register() async {
    setState(() => _loading = true);
    try {
      await Provider.of<AuthService>(context, listen: false)
          .signUp(_emailCtrl.text.trim(), _passCtrl.text);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 12),
            TextField(controller: _passCtrl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _loading ? null : _register, child: _loading ? CircularProgressIndicator() : Text('Create'))
          ],
        ),
      ),
    );
  }
}
