import 'package:chat_app2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:chat_app2/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), (){
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Damned Chat'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: const Duration(seconds: 1),
              height: mq.height * 0.6,
              width: mq.width * 0.6,
              right: _isAnimated ? mq.width * 0.20 : -mq.width * 0.60,
              top: mq.height * 0.05,
              child: SvgPicture.asset('images/icon.svg'),
          ),
          Positioned(
            bottom: mq.height * 0.15,
            left: mq.width * 0.25,
            child: SignInButton(Buttons.GoogleDark, onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            },),
          )
        ],
      ),
    );
  }
}
