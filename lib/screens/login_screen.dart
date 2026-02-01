import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    try {
      await Provider.of<AuthService>(context, listen: false)
          .signIn(_emailCtrl.text.trim(), _passCtrl.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('MyMessenger', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 12),
              TextField(controller: _passCtrl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _loading ? null : _login, child: _loading ? CircularProgressIndicator() : Text('Sign in')),
              SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())), child: Text('Create account'))
            ],
          ),
        ),
      ),
    );
  }
}
