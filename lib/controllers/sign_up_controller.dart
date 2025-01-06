import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String city,
    required String password,
  }) async {
    try {
      EasyLoading.show(status: 'Signing up...');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uId": userCredential.user!.uid,
        "username": name,
        "email": email,
        "phone": phone,
        "userImg": "",
        "city": city,
      });

      EasyLoading.dismiss();
      Get.snackbar("Success", "Account Created Successfully",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "Sign Up Failed: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      print("Sign Up Error: $e");
    }
  }}


// class UserModel {
//   final String uId;
//   final String username;
//   final String email;
//   final String phone;
//   final String userImg;
//   final String? userDeviceToken;
//   final String? country;
//   final String? userAddress;
//   final String? street;
//   final bool isAdmin;
//   final bool isActive;
//   //final DateTime? createdOn;
//   final String? city;
//
//   UserModel({
//     required this.uId,
//     required this.username,
//     required this.email,
//     required this.phone,
//     required this.userImg,
//     this.userDeviceToken,
//     this.country,
//     this.userAddress,
//     this.street,
//     this.isAdmin = false,
//     this.isActive = true,
//     //this.createdOn,
//     this.city,
//   });
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'uId': uId,
//       'username': username,
//       'email': email,
//       'phone': phone,
//       'userImg': userImg,
//       'userDeviceToken': userDeviceToken,
//       'country': country,
//       'userAddress': userAddress,
//       'street': street,
//       'isAdmin': isAdmin,
//       'isActive': isActive,
//       //'createdOn': createdOn != null ? Timestamp.fromDate(createdOn!) : null,
//       'city': city,
//     };
//   }
//
//
//   factory UserModel.fromMap(Map<String, dynamic> json) {
//     return UserModel(
//       uId: json['uId'] ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       userImg: json['userImg'] ?? '',
//       userDeviceToken: json['userDeviceToken'],
//       country: json['country'],
//       userAddress: json['userAddress'],
//       street: json['street'],
//       isAdmin: json['isAdmin'] ?? false,
//       isActive: json['isActive'] ?? true,
//       // createdOn: json['createdOn'] is Timestamp
//       //     ? (json['createdOn'] as Timestamp).toDate()
//       //     : null,
//       city: json['city'],
//     );
//   }
// }
