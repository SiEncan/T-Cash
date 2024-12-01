import 'package:flutter/material.dart';
import 'services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fintar/screen/login_checker/login_state_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginStateChecker(),
    );
  }
}
