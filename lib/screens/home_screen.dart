
import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/screens/auth/login_screen.dart';
import 'package:chat_app2/screens/user_profile.dart';
import 'package:chat_app2/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/chat_user.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ChatUser> list = [];
  @override
  void initState() {
    super.initState();
    APIs.getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damned Chat'),
        leading: const Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile(user: APIs.loggedUser,)));
          }, icon: const Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
        },
        child: Icon(Icons.add_comment_outlined),
      ),
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          if (list.isNotEmpty) {
            return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
                  return ChatUserCard(user: list[index],);
                });
        }
        else{
          return const Center(
            child: Text('Nothing to see here!', style: TextStyle(fontSize: 20),),
          );
          }
    }
      ),
    );
  }
}
