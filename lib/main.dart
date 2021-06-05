import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'signup_screen.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:SignupScreen(),
      title:appName,
      debugShowCheckedModeBanner: false,
    );
  }
}




