import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      EasyLoading.show();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        "Success",
        "Sign in successful!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(MainScreen());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to sign in. Please try again!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}