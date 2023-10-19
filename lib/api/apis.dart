import 'package:chat_app2/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //for auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for firestore db
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  //current user
  static late ChatUser loggedUser;

  //check if user exists
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }

  //For updating user info(called from profile screen)

  static Future<void> UpdateInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': loggedUser.name,
      'about': loggedUser.about
    });
  }
}