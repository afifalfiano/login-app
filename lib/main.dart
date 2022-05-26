import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/LoginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDAGHxVcblrmYazxWojSEsOAuBE3NWkzhU",
      appId: "1:847882218338:android:3e3ab3be3e56815e4e1a3b",
      messagingSenderId: "847882218338",
      projectId: "flutter-a2890",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Afif Alfiano',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const LoginPage(),
    );
  }
}
