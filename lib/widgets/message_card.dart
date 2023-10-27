import 'package:chat_app2/main.dart';
import 'package:chat_app2/models/message.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    if (APIs.user.uid == widget.message.fromID) {
      return _blueMessage();
    } else {
      return _greyMessage();
    }
  }

  //sender
  Widget _greyMessage() {
    if (widget.message.type == Type.text) {
      return BubbleSpecialOne(
        text: widget.message.msg,
        isSender: false,
        color: selectedTheme == 'Light'
            ? Colors.grey.shade300
            : Colors.grey.shade700,
        textStyle: TextStyle(
            fontSize: 20,
            color: selectedTheme == 'Light' ? Colors.black : Colors.white),
      );
    } else {
      return BubbleNormalImage(
        id: widget.message.sent,
        image: Image.network(widget.message.msg),
        color: selectedTheme == 'Light'
            ? Colors.grey.shade300
            : Colors.grey.shade700,
        isSender: false,
      );
    }
  }

  //Our message
  Widget _blueMessage() {
    if (widget.message.type == Type.text) {
      return BubbleSpecialOne(
        text: widget.message.msg,
        isSender: true,
        color: selectedColor,
        textStyle: const TextStyle(color: Colors.white, fontSize: 20),
      );
    } else {
      return BubbleNormalImage(
        id: widget.message.sent,
        image: Image.network(widget.message.msg),
        color: selectedColor,
        isSender: true,
      );
    }
  }
}
