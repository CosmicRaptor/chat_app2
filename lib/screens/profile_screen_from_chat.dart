import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/main.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:chat_app2/models/dateformatting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileFromChat extends StatelessWidget {
  final ChatUser user;

  const UserProfileFromChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedTheme == 'Light'
          ? Colors.white
          : const Color.fromRGBO(30, 30, 32, 1),
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: selectedColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                imageUrl: user.image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              user.email,
              style: TextStyle(
                  fontSize: 22,
                  color:
                      selectedTheme == 'Light' ? Colors.black : Colors.white70),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'About: ${user.about}',
              style: TextStyle(
                  fontSize: 16,
                  color:
                      selectedTheme == 'Light' ? Colors.black : Colors.white70),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Member since: ${DateUtil.getLastMessageTime(context: context, time: user.createdAt)}',
              style: TextStyle(
                  fontSize: 16,
                  color:
                      selectedTheme == 'Light' ? Colors.black : Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
