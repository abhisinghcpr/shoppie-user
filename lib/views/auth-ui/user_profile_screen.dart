import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user-model.dart';
import 'update_user_details_screen.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({Key? key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  late UserModel userData = UserModel(
    username: '',
    email: '',
    uId: '',
    phone: '',
    userImg: '',
    userDeviceToken: '',
    //createdOn: null,
    city: '',
  );

  File? _imageFile;
  final picker = ImagePicker();
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    fetchUserData();

  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userData.uId}.jpg');

      await ref.putFile(_imageFile!);

      // Get download URL
      String downloadURL = await ref.getDownloadURL();

      // Update Firestore document with image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.uId)
          .update({'userImg': downloadURL});
    }
  }



  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((DocumentSnapshot snapshot) {
          if (_isMounted && snapshot.exists) {
            setState(() {
              userData =
                  UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
            });
          }
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var profileView = UserScreenWidget(context: context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : userData.userImg.isNotEmpty
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    userData.userImg),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage("assets/images/img.png"),
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _uploadImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.photo,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    profileView.profileWidgets(
                        name: 'Name',
                        text: userData.username,
                        icon: Icons.person),
                    profileView.profileWidgets(
                        name: 'Email', text: userData.email, icon: Icons.email),
                    profileView.profileWidgets(
                        name: 'Phone',
                        text: userData.phone ?? "N/A",
                        // Use userData.phone directly
                        icon: Icons.phone_android),
                    profileView.profileWidgets(
                        name: 'Address', text: userData.city, icon: Icons.home),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateUserScreen(userData: userData),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

class UserScreenWidget {
  BuildContext context;

  UserScreenWidget({required this.context});

  Widget profileWidgets(
      {required String? name, required String? text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Card(
        child: Row(
          children: [
            Icon(icon, size: 30),
            SizedBox(
              width: 24,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(name!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )),
                SizedBox(
                  height: 4,
                ),
                Text(text ?? "N/A",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.grey))
              ],
            )
          ],
        ),
      ),
    );
  }
}
