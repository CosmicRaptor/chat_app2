import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/main.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileFromChat extends StatelessWidget {
  final ChatUser user;
  UserProfileFromChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
        backgroundColor: selectedColor,
      ),
      body: Center(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                imageUrl: user.image,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
