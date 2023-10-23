
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app2/api/apis.dart';
import 'package:chat_app2/api/local_database.dart';
import 'package:chat_app2/models/chat_user.dart';
import 'package:chat_app2/screens/auth/login_screen.dart';
import 'package:chat_app2/widgets/color_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';



class UserProfile extends StatefulWidget {
  final ChatUser user;
  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final _formKey = GlobalKey<FormState>();
  String? _image;

  getColor() async {
    selectedColor = Color(await DB.getColor());
    //print(selectedColor);
  }

  void setTheStateAfterButtonClick(){
    setState(() {
      getColor();
      selectedColor;
    });
  }

  @override
  void initState()  {
    getColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: selectedColor,
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
                      //Profile photo
                      _image != null ?
                          //Local image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.file(
                              width: 200,
                              height: 200,
                              File(_image!),
                              fit: BoxFit.cover,
                            ),
                          )
                            :
                          //Server image
                              ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                          child: CachedNetworkImage(
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.image,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                          ),
                        ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          left: 95,
                          child: MaterialButton(elevation: 0, onPressed: (){_showBottomSheet();}, color: Colors.white, shape: const CircleBorder(), child: const Icon(Icons.edit, color: Colors.blue,),))
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
                ColorPickerWidget(onColorSelected: () => setTheStateAfterButtonClick()),
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
                ),),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(){
    showModalBottomSheet(context: context, builder: (_){
      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        children:  [
          const Text('Select a profile picture', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(150, 200),
                    shape: const CircleBorder()
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null){
                      setState(() {
                        _image = image.path;
                      });
                    }
                    APIs.updateProfilePic(File(_image!));
                    Navigator.pop(context);
                  },
                  child: Image.asset('images/gallery.png')),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(150, 200),
                      shape: const CircleBorder()
                  ),
                  onPressed: ()async{
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null){
                      setState(() {
                        _image = image.path;
                      });
                    }
                    APIs.updateProfilePic(File(_image!));
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.add_a_photo, color: Colors.black, size: 100,)),
            ],
          )
        ],
      );
    });
  }
}
