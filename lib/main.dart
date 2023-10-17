import 'package:flutter/material.dart';
import 'package:chat_app2/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

//Screen size object
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Only allow app in portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) {
    _initialiseFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade900,
          centerTitle: true
        )
      ),
      home: LoginScreen(),
    );
  }
}

//Firebase initialisation
_initialiseFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}