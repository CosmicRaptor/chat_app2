import 'package:chat_app2/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //for auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for firestore db
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  //check if user exists
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //create new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(image: user.photoURL.toString(), about: "Rick Astley is da best", name: user.displayName.toString(), createdAt: time, id: user.uid, email: user.email.toString(), pushToken: '');
    await firestore.collection('users').doc(user.uid).set(chatuser.toJson());
  }
}