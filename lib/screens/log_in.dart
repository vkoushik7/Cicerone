import 'package:cicerone/screens/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cicerone/firebase_options.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
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
        appBar: AppBar(
          title: const Text('Cicerone'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            const Text('Login to Navigate',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email id',
                labelStyle: TextStyle(
                    color: Colors.black12,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: Colors.black12,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage())));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        await showErrorDialog(context, 'User not Found!');
                      } else if (e.code == 'wrong-password') {
                        await showErrorDialog(context, 'Incorrect Password!');
                      } else {
                        await showErrorDialog(context, 'Error: ${e.code}');
                      }
                    }
                  },
                )),
            TextButton(
                onPressed: () {
                  final email = _email.text;
                  if (email.isEmpty) {
                    showErrorDialog(
                        context, 'Enter your email to reset password');
                  } else {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    showErrorDialog(
                        context, 'Password reset link sent to your email');
                  }
                },
                child: const Text('Forgot Password?')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Don\'t have account? Sign up now'))
          ]),
        ));
  }
}
