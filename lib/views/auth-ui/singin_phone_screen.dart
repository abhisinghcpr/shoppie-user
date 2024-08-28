// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);
//
//   @override
//   State<SignUp> createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//   late TextEditingController _phoneNumberController;
//   String _verificationid = '';
//   int? _resendToken;
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _phoneNumberController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     super.dispose();
//   }
//
//   void _handleSignUp() async {
//     if (_phoneNumberController.text.length == 10) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Signing Up'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('Please wait...'),
//               ],
//             ),
//           );
//         },
//       );
//
//       try {
//         await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: '+91${_phoneNumberController.text}',
//           verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
//           verificationFailed: (FirebaseAuthException e) {
//             print("Exception: $e");
//
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             // Handle code sent
//             setState(() {
//               _verificationid = verificationId;
//               _resendToken = resendToken;
//             });
//             Navigator.pop(context);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OtpScreen(
//                   verificationId: _verificationid,
//                   resendToken: _resendToken,
//                   phone: '+91${_phoneNumberController.text}',
//                 ),
//               ),
//             );
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {
//             // Handle timeout
//           },
//         );
//       } catch (e) {
//         print("Exception: $e");
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//         Navigator.pop(context); // Dismiss the AlertDialog
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var view = AddCustomer(context: context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppConstant.appMainColor,
//         title: const Text(
//           'Sign Up',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Sign in with your phone number',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: _phoneNumberController,
//                       keyboardType: TextInputType.number,
//                       maxLength: 10,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.phone_android),
//                         labelText: 'Enter your phone number',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _handleSignUp,
//                   style: ButtonStyle(
//                     padding: MaterialStateProperty.all<EdgeInsets>(
//                         EdgeInsets.symmetric(vertical: 16)),
//                     backgroundColor: MaterialStateColor.resolveWith((states) {
//                       return _phoneNumberController.text.length == 10 &&
//                               !_isLoading
//                           ? Colors.blue
//                           : Colors.blueGrey;
//                     }),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Text(
//                           'Sign Up',
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
