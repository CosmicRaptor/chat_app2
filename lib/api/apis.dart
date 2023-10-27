import 'dart:io';

import 'package:chat_app2/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/message.dart';

class APIs {
  //for auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for firestore db
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for image db
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  //current user
  static late ChatUser loggedUser;

  //check if user exists
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //add user to chat list
  static Future<bool> addUser(String email) async {
    final data = await firestore.collection('users').where('email', isEqualTo: email).get();
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore.collection('users').doc(user.uid).collection('added_users').doc(data.docs.first.id).set({});
      return true;
    }
    else {
      return false;
    }
  }

  static Future<void> getLoggedInUser() async{
    await firestore.collection('users').doc(user.uid).get().then((user) async{
      if (user.exists){
        loggedUser = ChatUser.fromJson(user.data()!);
      }
      else{
        await createUser().then((value) => getLoggedInUser());
      }
    });
  }

  //create new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(image: user.photoURL.toString(), about: "Rick Astley is da best", name: user.displayName.toString(), createdAt: time, id: user.uid, email: user.email.toString(), pushToken: '');
    await firestore.collection('users').doc(user.uid).set(chatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIDs) {
    return firestore.collection('users').where('id', whereIn: userIDs.isEmpty ? [''] : userIDs).snapshots();
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersID() {
    return firestore.collection('users').doc(user.uid).collection('added_users').snapshots();
  }

  static Future<void> sendFirstMessage(ChatUser chatuser, String msg, Type type) async {
    await firestore.collection('users').doc(chatuser.id).collection('adder_users').doc(user.uid).set({}).then((value) => sendMessage(chatuser, msg, type));
  }

  //For updating user info(called from profile screen)

  static Future<void> UpdateInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': loggedUser.name,
      'about': loggedUser.about
    });
  }

  static Future<void> updateProfilePic(File file) async {
    final ref = storage.ref().child('profile_pics/${user.uid}.${file.path.split('.').last}');
    await ref.putFile(file);
    loggedUser.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': loggedUser.image
    });
  }

  ///Chat Screen related stuff is below!

  // gets conversation ID
  static String getConversationID (String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';
  // gets all messages of a conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firestore.collection('chats/${getConversationID(user.id)}/messages/').orderBy('sent', descending: true).snapshots();
  }

  //For sending message
  static Future<void> sendMessage(ChatUser chatuser, String message, Type type) async{
    //message sending time(used as ID)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final Message msg = Message(toID: chatuser.id, msg: message, type: type, fromID: user.uid, sent: time);
    final ref = firestore.collection('chats/${getConversationID(chatuser.id)}/messages/');
    await ref.doc(time).set(msg.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
    return firestore.collection('chats/${getConversationID(user.id)}/messages/').orderBy('sent', descending: true).limit(1).snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatuser, File file) async{
    final ref = storage.ref().child('images/${getConversationID(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}');
    await ref.putFile(file);
    final imageURL = await ref.getDownloadURL();
    await sendMessage(chatuser, imageURL, Type.image);
  }
}