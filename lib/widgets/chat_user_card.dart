import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:chat_app2/models/dateformatting.dart';
import 'package:chat_app2/models/message.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message(if null then no msg)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user,)));
        },
        child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot){
              final data = snapshot.data?.docs;
              //log('Data: ${jsonEncode(data![0].data())}');
              final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty){
                _message = list[0];
              }
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(_message != null ? _message!.msg : widget.user.about, maxLines: 1,),
                trailing: _message != null ? Text(DateUtil.getLastMessageTime(context: context, time: _message!.sent)) :Text(widget.user.createdAt),
              );
        })
      ),
    );
  }
}

