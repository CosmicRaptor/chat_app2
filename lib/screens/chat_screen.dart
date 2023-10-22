
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:chat_app2/models/message.dart';
import 'package:chat_app2/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Message> list = [];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.docs;
                      //log('Data: ${jsonEncode(data![0].data())}');
                      list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                      print(list);

                      if (list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index){
                              return MessageCard(message: list[index],);
                            });
                      }
                      else{
                        return Center(
                          child: Text('Say Hi to ${widget.user.name}', style: const TextStyle(fontSize: 20),),
                        );
                      }
                    }
                ),
              ),
              _chatInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back, color: Colors.white,)),

          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              width: 45,
              height: 45,
              imageUrl: widget.user.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
            ),
          ),
          const SizedBox(width: 20,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),),
              Text(widget.user.email, style: const TextStyle(fontSize: 16, color: Colors.white38),)
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          // Input field and buttons
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue, width: 2),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.emoji_emotions_outlined), color: Colors.lightBlue,),
                Expanded(child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(border: InputBorder.none,
                  hintText: 'Message'),
                  style: const TextStyle(color: Colors.black54),
                )),
                IconButton(onPressed: (){}, icon: const Icon(Icons.image_outlined), color: Colors.lightBlue,),
                IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt_outlined), color: Colors.lightBlue,),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5,),
        Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightBlue,
            ),
            child: IconButton(onPressed: (){
              if (_textController.text.isNotEmpty){
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            }, icon: const Icon(Icons.send, color: Colors.white,)))
      ],
    );
  }
}
