// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart'; // Add this import
// import 'package:shoppie/controllers/google_sign_in_controller.dart';
// import 'package:shoppie/controllers/sign_up_controller.dart';
// import 'package:shoppie/views/utils/app-constant.dart';
// import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';
// import 'package:shoppie/views/widgets/singup_widgits.dart';
//
//
// class SignUpScreen extends StatelessWidget {
//   final SignUpController _signUpController = Get.put(SignUpController());
//
//   final TextEditingController username = TextEditingController();
//   final TextEditingController userEmail = TextEditingController();
//   final TextEditingController userPhone = TextEditingController();
//   final TextEditingController userCity = TextEditingController();
//   final TextEditingController userPassword = TextEditingController();
//
//   bool isEmpty(String value) => value.trim().isEmpty;
//
//   @override
//   Widget build(BuildContext context) {
//     var view = AddCustomer(context: context);
//     return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppConstant.appScendoryColor,
//           title: const Text(
//             "Sign Up",
//             style: TextStyle(color: AppConstant.appTextColor),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 "SIGN UP TO GET STARTED..",
//                 style: TextStyle(
//                   color: AppConstant.appScendoryColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               view.fieldView(
//                 controller: username,
//                 text: "Name",
//                 icon: Icons.person,
//                 type: TextInputType.name,
//               ),
//               view.fieldView(
//                 controller: userEmail,
//                 text: "Email",
//                 icon: Icons.email,
//                 type: TextInputType.emailAddress,
//               ),
//               view.fieldView(
//                 controller: userPhone,
//                 text: "Phone",
//                 icon: Icons.phone,
//                 type: TextInputType.number,
//               ),
//               view.fieldView(
//                 controller: userCity,
//                 text: "City",
//                 icon: Icons.home,
//                 type: TextInputType.streetAddress,
//               ),
//               view.fieldView(
//                 controller: userPassword,
//                 text: "Password",
//                 icon: Icons.lock,
//                 type: TextInputType.visiblePassword,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppConstant.appScendoryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   minimumSize: Size(200, 40),
//                 ),
//                 onPressed: () async {
//                   if ([username, userEmail, userPhone, userCity, userPassword]
//                       .any((controller) => isEmpty(controller.text))) {
//                     Fluttertoast.showToast(
//                       msg: "Please fill in all fields",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       backgroundColor: Colors.red,
//                       textColor: Colors.white,
//                     );
//                     return;
//                   }
//
//                   try {
//                     // EasyLoading.show(status: 'Signing up...');
//                     await _signUpController.signUp(
//                       name: username.text.trim(),
//                       email: userEmail.text.trim(),
//                       phone: userPhone.text.trim(),
//                       city: userCity.text.trim(),
//                       password: userPassword.text.trim(),
//                     );
//                     // EasyLoading.dismiss();
//                     Fluttertoast.showToast(
//                       msg: "Sign Up successful!",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       backgroundColor: Colors.blue,
//                       textColor: Colors.white,
//                     );
//                     Get.offAll(() => MainScreen());
//                   } catch (e) {
//                     //EasyLoading.dismiss();
//                     Fluttertoast.showToast(
//                       msg: "Sign Up Failed! $e",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       backgroundColor: Colors.red,
//                       textColor: Colors.white,
//                     );
//                   }
//                 },
//                 child: const Text(
//                   "SIGN UP",
//                   style: TextStyle(color: AppConstant.appTextColor),
//                 ),
//               ),
//               const SizedBox(height: 10),
//
//               const SizedBox(height: 19),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Already have an account? ",
//                     style: TextStyle(color: AppConstant.appScendoryColor),
//                   ),
//                   GestureDetector(
//                   //  onTap: () => Get.to(() => SignInScreen()),
//                     child: const Text(
//                       "Sign In",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }


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

      if (name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || password.isEmpty) {
       // EasyLoading.showError('Please fill in all fields');
        return;
      }

     // EasyLoading.show(status: 'Signing up...');


      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: name,
        email: email,
        phone: phone,
        userImg: '',
        createdOn: DateTime.now(),
        city: city,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());

     // EasyLoading.dismiss();
     // EasyLoading.showSuccess('Sign up successful');
    } catch (e) {
      // EasyLoading.dismiss();
     // EasyLoading.showError('Sign up failed: ${e.toString()}');
      print("Error: ${e.toString()}");
    }
  }
}

class UserModel {
  final String uId;
  final String username;
  final String email;
  final String phone;
  final String userImg;
  final String? userDeviceToken;
  final String? country;
  final String? userAddress;
  final String? street;
  final bool isAdmin;
  final bool isActive;
  final DateTime? createdOn;
  final String? city;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.userImg,
    this.userDeviceToken,
    this.country,
    this.userAddress,
    this.street,
    this.isAdmin = false,
    this.isActive = true,
    this.createdOn,
    this.city,
  });


  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'country': country,
      'userAddress': userAddress,
      'street': street,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdOn': createdOn != null ? Timestamp.fromDate(createdOn!) : null,
      'city': city,
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userImg: json['userImg'] ?? '',
      userDeviceToken: json['userDeviceToken'],
      country: json['country'],
      userAddress: json['userAddress'],
      street: json['street'],
      isAdmin: json['isAdmin'] ?? false,
      isActive: json['isActive'] ?? true,
      createdOn: json['createdOn'] is Timestamp
          ? (json['createdOn'] as Timestamp).toDate()
          : null,
      city: json['city'],
    );
  }
}
