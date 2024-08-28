// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shoppie/screens/auth-ui/sign-in-screen.dart';
//
// import '../../controllers/google-sign-in-controller.dart';
// import '../../models/user-model.dart';
// import '../../utils/app-constant.dart';
// import '../../widgets/buttomnavigation-widgets.dart';
// import '../../widgets/singup_widgits.dart';
//
// class SignUpScreen extends StatefulWidget {
//   SignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
// // final GoogleSignInController signUpController = Get.put(GoogleSignInController());
//   TextEditingController username = TextEditingController();
//   TextEditingController userEmail = TextEditingController();
//   TextEditingController userPhone = TextEditingController();
//   TextEditingController userCity = TextEditingController();
//   TextEditingController userPassword = TextEditingController();
//
//   final GoogleSignInController _googleSignInController =
//       Get.put(GoogleSignInController());
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
//           child: Container(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: Get.height / 60),
//                 Container(
//                   alignment: Alignment.center,
//                   child: const Text(
//                     "SIGN UP TO GET STARTED..",
//                     style: TextStyle(
//                       color: AppConstant.appScendoryColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Get.height / 40),
//                 view.fieldView(
//                   controller: username,
//                   text: "Name",
//                   icon: Icons.person,
//                   type: TextInputType.name,
//                 ),
//                 view.fieldView(
//                   controller: userEmail,
//                   text: "Email",
//                   icon: Icons.email,
//                   type: TextInputType.emailAddress,
//                 ),
//                 view.fieldView(
//                   controller: userPhone,
//                   text: "Phone",
//                   icon: Icons.phone,
//                   type: TextInputType.number,
//                 ),
//                 view.fieldView(
//                   controller: userCity,
//                   text: "City",
//                   icon: Icons.home,
//                   type: TextInputType.streetAddress,
//                 ),
//                 view.fieldView(
//                   controller: userPassword,
//                   text: "Password",
//                   icon: Icons.lock,
//                   type: TextInputType.visiblePassword,
//                 ),
//                 SizedBox(height: Get.height / 60),
//                 ElevatedButton(
//                   onPressed: () async {
//                     String email = userEmail.text.trim();
//                     String name = username.text.trim();
//                     String phone = userPhone.text.trim();
//                     String city = userCity.text.trim();
//                     String password = userPassword.text.trim();
//
//                     if (name.isNotEmpty &&
//                         email.isNotEmpty &&
//                         phone.isNotEmpty &&
//                         city.isNotEmpty &&
//                         password.isNotEmpty) {
//                       try {
//                         EasyLoading.show(status: "Please wait..");
//                         UserCredential userCredential = await FirebaseAuth
//                             .instance
//                             .createUserWithEmailAndPassword(
//                           email: email,
//                           password: password,
//                         );
//
//                         UserModel userModel = UserModel(
//                           uId: userCredential.user!.uid,
//                           username: name,
//                           email: email,
//                           phone: phone,
//                           userImg: '',
//                           userDeviceToken: "",
//                           createdOn: DateTime.now(),
//                           city: city,
//                         );
//
//                         await FirebaseFirestore.instance
//                             .collection('users')
//                             .doc(userCredential.user!.uid)
//                             .set(userModel.toMap());
//                         EasyLoading.dismiss();
//
//                         Fluttertoast.showToast(
//                           msg: "Sign Up successfully!",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: Colors.blue,
//                           textColor: Colors.white,
//                         );
//
//                         Get.offAll(() => MainScreen());
//                       } catch (e) {
//                         EasyLoading.dismiss();
//                         Fluttertoast.showToast(
//                           msg: "Sign Up Failed!$e",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: Colors.red,
//                           textColor: Colors.white,
//                         );
//                       }
//                     } else {
//                       Fluttertoast.showToast(
//                         msg: "Please fill  All field",
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.green,
//                         textColor: Colors.white,
//                       );
//                     }
//                   },
//                   child: Text(
//                     "SIGN UP",
//                     style: TextStyle(color: AppConstant.appTextColor),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppConstant.appScendoryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Get.height / 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already have an account? ",
//                       style: TextStyle(color: AppConstant.appScendoryColor),
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SignInScreen(),
//                           )),
//                       child: const Text(
//                         "Sign In",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Material(
//                   child: Center(
//                     child: Container(
//                       width: 200,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: AppConstant.appScendoryColor,
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: TextButton.icon(
//                         icon: Image.asset(
//                           'assets/images/final-google-logo.png',
//                           width: 30,
//                           height: 40,
//                         ),
//                         label: Text(
//                           "Sign in with google",
//                           style: TextStyle(color: AppConstant.appTextColor),
//                         ),
//                         onPressed: () {
//                           _googleSignInController.signInWithGoogle();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Material(
//                 //   child: Center(
//                 //     child: Container(
//                 //       width: 200,
//                 //       height: 40,
//                 //       decoration: BoxDecoration(
//                 //         color: AppConstant.appScendoryColor,
//                 //         borderRadius: BorderRadius.circular(20.0),
//                 //       ),
//                 //       child: TextButton.icon(
//                 //         icon: Image.asset(
//                 //           'assets/images/mobile-phone.png',
//                 //           width: 30,
//                 //           height: 40,
//                 //         ),
//                 //         label: Text(
//                 //           "Sign in with Phone",
//                 //           style: TextStyle(color: AppConstant.appTextColor),
//                 //         ),
//                 //         onPressed: () {
//                 //           Navigator.push(
//                 //               context,
//                 //               MaterialPageRoute(
//                 //                 builder: (context) => SignUp(),
//                 //               ));
//                 //         },
//                 //       ),
//                 //     ),
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Add this import
import 'package:shoppie/controllers/google_sign_in_controller.dart';
import 'package:shoppie/controllers/sign_up_controller.dart';
import 'package:shoppie/views/utils/app-constant.dart';
import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';
import 'package:shoppie/views/widgets/singup_widgits.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController _signUpController = Get.put(SignUpController());

  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  bool isempty(String value) {
    return value.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var view = AddCustomer(context: context);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScendoryColor,
          title: const Text(
            "Sign Up",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height / 60),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "SIGN UP TO GET STARTED..",
                    style: TextStyle(
                      color: AppConstant.appScendoryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(height: Get.height / 40),
                view.fieldView(
                  controller: username,
                  text: "Name",
                  icon: Icons.person,
                  type: TextInputType.name,
                ),
                view.fieldView(
                  controller: userEmail,
                  text: "Email",
                  icon: Icons.email,
                  type: TextInputType.emailAddress,
                ),
                view.fieldView(
                  controller: userPhone,
                  text: "Phone",
                  icon: Icons.phone,
                  type: TextInputType.number,
                ),
                view.fieldView(
                  controller: userCity,
                  text: "City",
                  icon: Icons.home,
                  type: TextInputType.streetAddress,
                ),
                view.fieldView(
                  controller: userPassword,
                  text: "Password",
                  icon: Icons.lock,
                  type: TextInputType.visiblePassword,
                ),
                SizedBox(height: Get.height / 60),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      if (isempty(username.text) ||
                          isempty(userEmail.text) ||
                          isempty(userPhone.text) ||
                          isempty(userCity.text) ||
                          isempty(userPassword.text)) {
                        Fluttertoast.showToast(
                          msg: "Please fill in all fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      try {
                        EasyLoading.show(
                            status: 'Signing up...');

                        await _signUpController.signUp(
                          name: username.text.trim(),
                          email: userEmail.text.trim(),
                          phone: userPhone.text.trim(),
                          city: userCity.text.trim(),
                          password: userPassword.text.trim(),
                        );

                        EasyLoading.dismiss();
                        Fluttertoast.showToast(
                          msg: "Sign Up successfully!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                        );
                        Get.offAll(() => MainScreen());
                      } catch (e) {
                        EasyLoading.dismiss(); // Dismiss loading indicator
                        Fluttertoast.showToast(
                          msg: "Sign Up Failed! $e",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),

                  ),
                ),
                SizedBox(
                  height: 10,
                ),
               Text("Or ,"),
                SizedBox(
                  height: 10,
                ),
                Material(
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppConstant.appScendoryColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton.icon(
                        icon: Image.asset(
                          'assets/images/final-google-logo.png',
                          width: 30,
                          height: 40,
                        ),
                        label: Text(
                          "Sign in with google",
                          style: TextStyle(color: AppConstant.appTextColor),
                        ),
                        onPressed: () {
                          _googleSignInController.signInWithGoogle();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: AppConstant.appScendoryColor),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => SignInScreen()),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
