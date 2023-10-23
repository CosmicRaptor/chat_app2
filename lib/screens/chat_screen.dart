
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/main.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:chat_app2/models/message.dart';
import 'package:chat_app2/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: selectedColor,
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
                      //print(list);

                      if (list.isNotEmpty) {
                        return ListView.builder(
                          reverse: true,
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
              _chatInput(),
              if (_showEmoji == true)
                SizedBox(
                  height: 300,
                  child: EmojiPicker(

                  textEditingController: _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                  config: const Config(
                    columns: 7,
                    emojiSizeMax: 32 * (1.0)
                  )
                ))
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
                border: Border.all(color: selectedColor, width: 2),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                IconButton(onPressed: (){
                  setState(() {
                    _showEmoji =! _showEmoji;
                    //print(_showEmoji);
                  });
                }, icon:  const Icon(Icons.emoji_emotions_outlined), color: selectedColor,),
                Expanded(child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(border: InputBorder.none,
                  hintText: 'Message'),
                  style: const TextStyle(color: Colors.black54),
                )),
                IconButton(onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final List<XFile> images = await picker.pickMultiImage();
                  if (images.isNotEmpty){
                    for (var i in images){
                      await APIs.sendChatImage(widget.user, File(i.path));
                    }
                  }
                }, icon: const Icon(Icons.image_outlined), color: selectedColor,),
                IconButton(onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null){
                    await APIs.sendChatImage(widget.user, File(image.path));
                  }
                }, icon: const Icon(Icons.camera_alt_outlined), color: selectedColor,),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5,),
        Container(
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: selectedColor,
            ),
            child: IconButton(onPressed: (){
              if (_textController.text.isNotEmpty){
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            }, icon: const Icon(Icons.send, color: Colors.white,)))
      ],
    );
  }
}
