import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damned Chat'),
        leading: const Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add_comment_outlined),
      ),
    );
  }
}
