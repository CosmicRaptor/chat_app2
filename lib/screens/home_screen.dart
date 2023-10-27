
import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/main.dart';
import 'package:chat_app2/screens/user_profile.dart';
import 'package:chat_app2/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _changeState(){
    setState(() {
      selectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedTheme == 'Light' ? Colors.white : const Color.fromRGBO(30, 30, 32, 1),
      appBar: AppBar(
        backgroundColor: selectedColor,
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
            Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile(user: APIs.loggedUser, updateState:() => _changeState(),)));
          }, icon: const Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: selectedColor,
        onPressed: () {
          _addChatUserDialog();
        },
        child: const Icon(Icons.add_comment_outlined),
      ),
      body: StreamBuilder(stream: APIs.getMyUsersID() ,builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.none:
            return  Center(child: Text('Loading!', style: TextStyle(fontSize: 20, color: selectedTheme == 'Light' ? Colors.black : Colors.white70),));

          case ConnectionState.active:
          case ConnectionState.done:

            return StreamBuilder(
              stream: APIs.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []),
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
                  return Center(
                    child: Text('Nothing to see here!', style: TextStyle(fontSize: 20, color: selectedTheme == 'Light' ? Colors.black : Colors.white70),),
                  );
                }
              }
          );
      }}),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: selectedTheme == 'Light' ? Colors.white : const Color.fromRGBO(30, 30, 32, 1),
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),

          //title
          title: Row(
            children: [
              Icon(
                Icons.person_add,
                color: selectedColor,
                size: 28,
              ),
              const SizedBox(width: 10,),
              Text('Add user', style: TextStyle(color: selectedTheme == 'Light' ? Colors.black : Colors.white70),)
            ],
          ),

          //content
          content: TextFormField(
            maxLines: null,
            style: TextStyle(color: selectedTheme == 'Light' ? Colors.black : Colors.white70),
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: 'example@example.com',
                hintStyle: TextStyle(color: selectedTheme == 'Light' ? Colors.black45 : Colors.white30),
                prefixIcon: Icon(Icons.email_outlined, color: selectedColor,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),)),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )),

            //update button
            MaterialButton(
                onPressed: () {
                  if(email.isNotEmpty) {
                    APIs.addUser(email).then((value) {
                      if(!value) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops! Could not add that user.', textAlign: TextAlign.center,)));
                      }
                    });
                  }
                  //hide alert dialog
                  Navigator.pop(context);
                  //APIs.updateMessage(widget.message, updatedMsg);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}
