import 'package:chat_app2/screens/loading.dart';
import 'package:flutter/material.dart';
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
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
      home: LoadingScreen(),
    );
  }
}

//Firebase initialisation
_initialiseFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}