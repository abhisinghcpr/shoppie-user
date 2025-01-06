import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppie/controllers/sign_in_controller.dart';
import '../../controllers/google_sign_in_controller.dart';
import '../utils/app-constant.dart';
import '../widgets/singup_widgits.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    var view = AddCustomer(context: context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Sign In",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(


  child: Column(
          children: [
            SizedBox(height: 40),
            Column(
              children: [
                Image.asset('assets/images/welcomebacklogin.jpg', width: 340),
              ],
            ),
            SizedBox(height: 50),
            view.fieldView(
              controller: userEmail,
              text: "Enter your email",
              icon: Icons.email,
              type: TextInputType.emailAddress,
            ),
            view.fieldView(
              controller: userPassword,
              text: "Enter your password",
              icon: Icons.lock,
              type: TextInputType.number,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 20),
            Material(
              child: Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  onPressed: () {
                    if (userEmail.text.isEmpty || userPassword.text.isEmpty) {
                      Get.snackbar("Error", "Please fill in all fields");
                    } else {
                      authController.signInWithEmailAndPassword(
                          userEmail.text, userPassword.text);
                    }
                  },
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(color: Colors.white),
                  ),
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
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.blue),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
