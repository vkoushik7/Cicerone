import 'package:cicerone/screens/verify_mail_view.dart';
import 'package:flutter/material.dart';
import 'package:cicerone/screens/log_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cicerone/firebase_options.dart';
import 'package:cicerone/screens/show_error_dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confrmpswrd;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confrmpswrd = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confrmpswrd.dispose();
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
            const Text('Signup to Navigate',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                  labelStyle: TextStyle(
                      color: Colors.black12,
                      fontSize: 12,
                      fontWeight: FontWeight.normal)),
            ),
            TextField(
              controller: _email,
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
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: Colors.black12,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ),
            TextField(
              controller: _confrmpswrd,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Confirm Password',
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
                    int flag = 0;
                    if (_password.text == _confrmpswrd.text) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final user = FirebaseAuth.instance.currentUser;
                        user?.updateDisplayName(_username.text);
                        await user?.sendEmailVerification();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VerifyEmailView()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          await showErrorDialog(context, 'Weak Password!');
                        } else if (e.code == 'email-already-in-use') {
                          await showErrorDialog(
                              context, 'Account already Exists!');
                        } else if (e.code == 'invalid-email') {
                          await showErrorDialog(
                              context, 'Invalid Email Adress');
                        } else {
                          await showErrorDialog(context, 'Error: ${e.code}');
                        }
                      }
                    } else {
                      await showErrorDialog(
                          context, 'Confirm Password Does not match!');
                    }
                  },
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text('Already a user? Log in!'))
          ]),
        ));
  }
}
