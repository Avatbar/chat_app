import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    print(_userEmail);
    print(_userPassword);

    try {
      if (_isLogin) {
        // Log user in
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        print(userCredentials);
      } else {
        // Sign user up
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        print(userCredentials);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed!'),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 94,
                  ),
                  width: 400,
                  child: Image.asset('assets/images/chat.png'),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              decoration:
                              const InputDecoration(labelText: 'Email address'),
                              validator: (value) {
                                if (value == null ||
                                    value
                                        .trim()
                                        .isEmpty ||
                                    value.isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userEmail = value!;
                              },
                            ),
                            TextFormField(
                              decoration:
                              const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null ||
                                    value
                                        .trim()
                                        .isEmpty ||
                                    value.isEmpty ||
                                    value
                                        .trim()
                                        .length < 7) {
                                  return 'Password must be at least 7 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userPassword = value!;
                              },
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .primaryContainer,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 8),
                              ),
                              child: Text(_isLogin ? 'Login' : 'Sign up'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create new account'
                                  : 'I already have an account'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
