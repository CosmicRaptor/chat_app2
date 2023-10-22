import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/screens/auth/login_screen.dart';
import 'package:chat_app2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), (){
      SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.indigo.shade900));

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
