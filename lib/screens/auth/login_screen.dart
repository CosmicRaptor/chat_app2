import 'dart:developer';
import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:chat_app2/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  _googleLoginButtonClick(){
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator(),));
    _signInWithGoogle().then((user) async{
      log(user.user.toString());
      log(user.additionalUserInfo.toString());
      Navigator.pop(context);
      if ((await APIs.userExist())){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));}

      else {
        await APIs.createUser().then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        });
      }}
    );
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await APIs.auth.signInWithCredential(credential);
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
              _googleLoginButtonClick();
            },),
          )
        ],
      ),
    );
  }
}
