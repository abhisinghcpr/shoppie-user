import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/buttomnavigation_widgets.dart';
import 'Intro_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (user != null) {
        Get.off(() => MainScreen());
      } else {
        Get.offAll(() => IntroPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FadeInDown(
                duration: const Duration(milliseconds: 2000),
                child: Image.asset(
                  "assets/images/splash_image1.png",
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            Text(
              "STYLISH",
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Text(
                "Find Your Style",
                style: TextStyle(
                  color: Colors.white,
                  // fontStyle: FontStyle.values[Constraints],
                  fontFamily: "italic",
                  fontSize: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
