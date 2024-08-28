//
//
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// import '../models/user-model.dart';
//
//
// class ProfileController extends GetxController {
//   UserModel? _userData;
//   File? _imageFile;
//   String? _imageUrl;
//   final picker = ImagePicker();
//
//   UserModel? get userData => _userData;
//
//   File? get imageFile => _imageFile;
//
//   String? get imageUrl => _imageUrl;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserData();
//   }
//
//   void fetchUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .snapshots()
//             .listen((DocumentSnapshot snapshot) {
//           if (snapshot.exists) {
//             _userData =
//                 UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
//             update();
//           }
//         });
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//     }
//   }
//
//   Future<void> uploadImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       _imageFile = File(pickedFile.path);
//
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child('user_images')
//           .child('${_userData?.uId}.jpg');
//
//       await ref.putFile(_imageFile!);
//
//       String downloadURL = await ref.getDownloadURL();
//
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_userData!.uId)
//           .update({'userImg': downloadURL});
//
//       _imageUrl = downloadURL;
//       update(); // Trigger rebuild after image upload
//     }
//   }
// }

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../models/user-model.dart';
//
// class ProfileController extends GetxController {
//   Rx<UserModel> userData = UserModel(
//           uId: '',
//           username: '',
//           email: '',
//           userImg: '',
//           userDeviceToken: '',
//           createdOn: null,
//           city: '')
//       .obs;
//   Rx<File?> imageFile = Rx<File?>(null);
//
//   final picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserData();
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .snapshots()
//             .listen((DocumentSnapshot snapshot) {
//           if (snapshot.exists) {
//             userData.value =
//                 UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
//           }
//         });
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//     }
//   }
//
//   Future<void> uploadImage() async {
//     try {
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//       if (pickedFile != null) {
//         imageFile.value = File(pickedFile.path);
//
//         Reference ref = FirebaseStorage.instance
//             .ref()
//             .child('user_images')
//             .child('${userData.value.uId}.jpg');
//
//         await ref.putFile(imageFile.value!);
//
//         String downloadURL = await ref.getDownloadURL();
//
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userData.value.uId)
//             .update({'userImg': downloadURL});
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//   }
// }
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/user-model.dart';

class ProfileController extends GetxController {
  late UserModel userData = UserModel(
    username: '',
    email: '',
    uId: '',
    phone: '',
    userImg: '',
    userDeviceToken: '',
    createdOn: null,
    city: '',
  );

  File? _imageFile;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchPhone();
  }

  Future<void> fetchPhone() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (user.phoneNumber != null) {
          String userr = user.phoneNumber!;
          print("Phone Number: $user");
        } else {
          print("User's phone number is not available.");
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
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
          if (snapshot.exists) {
            userData = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
            update();
          }
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userData.uId}.jpg');

      await ref.putFile(_imageFile!);

      String downloadURL = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.uId)
          .update({'userImg': downloadURL});

      fetchUserData(); // Update user data after image upload
    }
  }
}