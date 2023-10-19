
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:chat_app2/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



class UserProfile extends StatefulWidget {
  final ChatUser user;
  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () async{
          await FirebaseAuth.instance.signOut().then((value) async{
            await GoogleSignIn().signOut().then((value) {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
            });
          });
        },
        icon: const Icon(Icons.exit_to_app_rounded),
        label: const Text('Logout'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CachedNetworkImage(
                          //width: 200,
                          //height: 200,
                          imageUrl: widget.user.image,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          left: 45,
                          child: MaterialButton(elevation: 0, onPressed: (){}, color: Colors.white, shape: const CircleBorder(), child: const Icon(Icons.edit, color: Colors.blue,),))
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Text(widget.user.email, style: const TextStyle(color: Colors.black54, fontSize: 16),),
                const SizedBox(height: 40,),
                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (val) => APIs.loggedUser.name = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    label: const Text('Username')
                  ),
                ),
                const SizedBox(height: 40,),
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val) => APIs.loggedUser.about = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration:  InputDecoration(
                      prefixIcon: const Icon(Icons.edit, color: Colors.blue,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      label: const Text('About me')
                  ),
                ),
                const SizedBox(height: 50,),
                ElevatedButton.icon(onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    APIs.UpdateInfo().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!', textAlign: TextAlign.center,)));
                    });
                  }
                }, icon: const Icon(Icons.save), label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size(200, 50)
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
