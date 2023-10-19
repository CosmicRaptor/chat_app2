
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
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ?
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Name/Email',
                hintStyle: TextStyle(fontSize: 17, color: Colors.white)
              ),
              autofocus: true,
              style: const TextStyle(
                fontSize: 17, color: Colors.white, letterSpacing: 1,
              ),
              onChanged: (val){
                _searchList.clear();
                for (var i in list){
                  if (i.name.toLowerCase().contains(val) || i.email.toLowerCase().contains(val)){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            )
            : const Text('Damned Chat'),
        leading: const Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              _isSearching = !_isSearching;
            });
          }, icon: Icon(_isSearching ? Icons.cancel : Icons.search)),
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
                itemCount: _isSearching ? _searchList.length : list.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index){
                  return ChatUserCard(user: _isSearching ? _searchList[index] : list[index],);
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
