import 'package:flutter/material.dart';
import 'package:cicerone/screens/home_screen.dart';
import 'package:cicerone/screens/log_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cicerone/firebase_options.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _Username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _Username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _Username.dispose();
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
            const Text('Signup to Navigate',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            TextField(
              controller: _Username,
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
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );
                    final username = _Username.text;
                    final email = _email.text;
                    final password = _password.text;
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password)
                        .then((value) {
                      print("Created new account");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
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
