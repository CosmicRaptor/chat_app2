import 'package:chat_app2/models/chat_user.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: (){},
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.add_a_photo),),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about, maxLines: 1,),
          trailing: Text(widget.user.createdAt),
        ),
      ),
    );
  }
}

