

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shoppie/views/auth-ui/sign_in_screen.dart';

import '../../controllers/google_sign_in_controller.dart';
import '../../controllers/sign_up_controller.dart';
import '../utils/app-constant.dart';
import '../widgets/buttomnavigation_widgets.dart';
import '../widgets/singup_widgits.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController _signUpController = Get.put(SignUpController());
  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());

  final TextEditingController username = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPhone = TextEditingController();
  final TextEditingController userCity = TextEditingController();
  final TextEditingController userPassword = TextEditingController();

  bool isEmpty(String value) => value.trim().isEmpty;

  void _signUp() async {
    if ([username, userEmail, userPhone, userCity, userPassword].any((controller) => isEmpty(controller.text))) {
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
      await _signUpController.signUp(
        name: username.text.trim(),
        email: userEmail.text.trim(),
        phone: userPhone.text.trim(),
        city: userCity.text.trim(),
        password: userPassword.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Sign Up successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
      Get.offAll(() => MainScreen());
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Sign Up Failed! $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var view = AddCustomer(context: context);

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScendoryColor,
          title: const Text("Sign Up", style: TextStyle(color: AppConstant.appTextColor)),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "SIGN UP TO GET STARTED..",
                style: TextStyle(
                  color: AppConstant.appScendoryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20),
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
                type: TextInputType.phone,
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appScendoryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  minimumSize: const Size(200, 40),
                ),
                onPressed: _signUp,
                child: const Text("SIGN UP", style: TextStyle(color: AppConstant.appTextColor)),
              ),
              const SizedBox(height: 10),
              const Text("Or,"),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appScendoryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  minimumSize: const Size(200, 40),
                ),
                icon: Image.asset('assets/images/final-google-logo.png', width: 30, height: 30),
                label: const Text("Sign in with Google", style: TextStyle(color: AppConstant.appTextColor)),
                onPressed: () {
                  _googleSignInController.signInWithGoogle();
                },
              ),
              const SizedBox(height: 19),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: AppConstant.appScendoryColor)),
                  GestureDetector(
                    onTap: () => Get.to(() => SignInScreen()),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
