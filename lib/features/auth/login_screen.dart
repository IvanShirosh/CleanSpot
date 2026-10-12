import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/firestore_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firestore = FirestoreService();
  bool _isSignUp = false;
  bool _loading = false;
  String? _error;

  Future<void> _run(Future<UserCredential> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cred = await action();
      final user = cred.user;
      if (user != null) {
        await _firestore.createUserIfMissing(
          user.uid,
          user.displayName ?? user.email?.split('@').first ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } on GoogleSignInException catch (e) {
      if (mounted) setState(() => _error = e.description ?? 'Google sign-in failed');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() {
    final auth = FirebaseAuth.instance;
    final email = _email.text.trim();
    return _run(
      () => _isSignUp
          ? auth.createUserWithEmailAndPassword(
              email: email,
              password: _password.text,
            )
          : auth.signInWithEmailAndPassword(
              email: email,
              password: _password.text,
            ),
    );
  }

  Future<void> _google() {
    return _run(() async {
      final google = GoogleSignIn.instance;
      await google.initialize();
      final account = await google.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      return FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CleanSpot',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(_isSignUp ? 'Sign up' : 'Log in'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : _google,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Continue with Google'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp ? 'Have an account? Log in' : 'No account? Sign up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
