import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/user-model.dart';

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
      if (name.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          city.isEmpty ||
          password.isEmpty) {
        EasyLoading.showError('Please fill in all fields');
        return;
      }

      EasyLoading.show(status: 'Signing up...');

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: name,
        email: email,
        phone: phone,
        userImg: '',
        userDeviceToken: "",
        createdOn: DateTime.now(),
        city: city,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Sign up successful');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Sign up failed. Please try again');
      throw e;
    }
  }
}
