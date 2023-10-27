import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/screens/auth/login_screen.dart';
import 'package:chat_app2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async{
      SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(systemNavigationBarColor: selectedTheme == 'Light' ? Colors.white : const Color.fromRGBO(30, 30, 32, 1), statusBarColor: selectedColor));
      if(APIs.auth.currentUser != null) {
        //Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      else{
        //Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return const Center(child: CircularProgressIndicator(),);
  }
}
