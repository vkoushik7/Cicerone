import 'package:cicerone/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/log_in.dart';
import 'screens/sign_up.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: 'Cicerone',
    home: SignupPage(),
    debugShowCheckedModeBanner: false,
  ));
}
