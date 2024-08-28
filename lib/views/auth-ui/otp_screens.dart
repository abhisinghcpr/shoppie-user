// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:shoppie/views/utils/app-constant.dart';
// import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';
//
// import 'phone-auth-user-details.dart';
//
//
// class OtpScreen extends StatefulWidget {
//   String verificationId;
//   int? resendToken;
//   final String phone;
//
//   OtpScreen(
//       {super.key,
//       required this.verificationId,
//       this.resendToken,
//       required this.phone});
//
//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController _otpController = TextEditingController();
//   bool _isFilled = false;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   var uid = FirebaseFirestore.instance.collection("users").id;
//   final FocusNode pinPut = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppConstant.appMainColor,
//         title: Text(
//           'OTP Verification',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Enter the OTP sent to your phone',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 40),
//             PinCodeTextField(
//               appContext: context,
//               length: 6,
//               controller: _otpController,
//               onChanged: (value) {
//                 setState(() {
//                   _isFilled = value.length == 6;
//                 });
//               },
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(10),
//                 fieldHeight: 50,
//                 fieldWidth: 40,
//                 activeColor: Colors.green,
//                 inactiveColor: Colors.grey,
//                 selectedColor: Colors.green,
//                 selectedFillColor: Colors.green.withOpacity(0.1),
//                 borderWidth: 2,
//                 disabledColor: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: _isFilled
//                       ? () async {
//                           // Verify OTP logic
//                           try {
//                             PhoneAuthCredential credential =
//                                 PhoneAuthProvider.credential(
//                               verificationId: widget.verificationId,
//                               smsCode: _otpController.text.toString(),
//                             );
//                             var data = await FirebaseAuth.instance
//                                 .signInWithCredential(credential);
//                             if (data.user?.uid != null) {
//                               var userData = await FirebaseFirestore.instance
//                                   .collection("users")
//                                   .doc(data.user?.uid ?? "")
//                                   .get();
//                               if (userData.exists) {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => MainScreen()));
//                               } else {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => PhoneSignUpScreen(),
//                                     ));
//                               }
//                             }
//                           } catch (ex) {
//                             log(ex.toString());
//                           }
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
//                     backgroundColor: _isFilled ? Colors.green : Colors.grey,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text('Verify OTP', style: TextStyle(fontSize: 16)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 // Resend OTP logic
//                 _resendOTP();
//               },
//               child: Text(
//                 'Resend OTP',
//                 style: TextStyle(fontSize: 16, color: Colors.blue),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _resendOTP() async {
//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: "+91${widget.phone}",
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException e) {
//           // Handle verification failure
//           print("Verification Failed: ${e.message}");
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           // Handle code sent
//           print("OTP Resent");
//           widget.resendToken = resendToken;
//           widget.verificationId = verificationId;
//         },
//         forceResendingToken: widget.resendToken,
//         codeAutoRetrievalTimeout: (String verificationId) {
//           widget.verificationId = verificationId;
//         },
//         timeout: Duration(seconds: 60), // Resend timeout (optional)
//       );
//     } catch (e) {
//       // Handle exceptions
//       print("Exception: $e");
//     }
//   }
// }
