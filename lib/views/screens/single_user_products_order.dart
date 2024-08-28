// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shoppie/controllers/cart_price_controller.dart';
// import 'package:shoppie/controllers/get_customer_device_token_controller.dart';
// import 'package:shoppie/views/utils/app-constant.dart';
// import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';
// import 'package:shoppie/views/widgets/singup_widgits.dart';
// import '../../controllers/user_singler_order_controller.dart';
// import '../../models/product-model.dart';
//
//
// class SingleProductsOrders extends StatefulWidget {
//   SingleProductsOrders({Key? key, required this.productModel});
//
//   ProductModel productModel;
//
//   @override
//   State<SingleProductsOrders> createState() => _SingleProductsOrdersState();
// }
//
// class _SingleProductsOrdersState extends State<SingleProductsOrders> {
//   late String userId;
//
//   void fetchUserDetails() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       if (userDoc.exists) {
//         Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//
//         setState(() {
//           nameController.text = userData['username'] ?? '';
//           phoneController.text = userData['phone'] ?? '';
//           emailController.text = userData['city'] ?? '';
//           addressController.text = userData['email'] ?? '';
//         });
//       }
//     } catch (e) {
//       print("Error fetching user details: $e");
//     }
//   }
//
//   final ProductPriceController productPriceController =
//       Get.put(ProductPriceController());
//   var nameController = TextEditingController();
//   var phoneController = TextEditingController();
//   var emailController = TextEditingController();
//   var addressController = TextEditingController();
//   late Razorpay _razorpay;
//   bool _isProcessingPayment = false;
//
//   @override
//   void initState() {
//     super.initState();
//     userId = FirebaseAuth.instance.currentUser!.uid;
//     fetchUserDetails();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     print("Payment Successful");
//     Get.snackbar(
//       "Orders Confirmed",
//       "Thank you for your orders!",
//       backgroundColor: AppConstant.appMainColor,
//       colorText: Colors.white,
//       duration: Duration(seconds: 3),
//     );
//
//     Get.offAll(() => MainScreen());
//
//     String customerToken = await getCustomerDeviceToken();
//     SingleOrder(
//         context: context,
//         customerName: nameController.text,
//         customerPhone: phoneController.text,
//         customerAddress: addressController.text,
//         customerDeviceToken: customerToken,
//         customerEmail: emailController.text,
//         quantity: 1,
//         productModel: widget.productModel);
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Payment Failed: ${response.message}");
//     setState(() {
//       _isProcessingPayment = false;
//     });
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("External Wallet: ${response.walletName}");
//   }
//
//   void _openCheckout(double amount) {
//     var options = {
//       'key': 'rzp_test_JBkzkSNWNiCv41',
//       'amount': (amount * 100).toInt(),
//       'name': 'Shoppie',
//       'description': 'Payment for products',
//       'prefill': {
//         'contact': phoneController.text,
//         'email': emailController.text,
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: ${e.toString()}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var view = AddCustomer(context: context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppConstant.appMainColor,
//         title: Text(
//           'Order ',
//           style: TextStyle(color: AppConstant.appTextColor),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 50,
//             ),
//             view.fieldView(
//                 controller: nameController,
//                 text: "Name",
//                 icon: CupertinoIcons.person,
//                 type: TextInputType.text),
//             SizedBox(
//               height: 10,
//             ),
//             view.fieldView(
//                 controller: phoneController,
//                 text: "Phone",
//                 icon: CupertinoIcons.phone,
//                 type: TextInputType.phone),
//             SizedBox(
//               height: 10,
//             ),
//             view.fieldView(
//                 controller: emailController,
//                 text: "Email",
//                 icon: Icons.email,
//                 type: TextInputType.emailAddress),
//             SizedBox(
//               height: 10,
//             ),
//             view.fieldView(
//                 controller: addressController,
//                 text: "Address",
//                 icon: CupertinoIcons.home,
//                 type: TextInputType.text),
//             SizedBox(
//               height: 40,
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppConstant.appMainColor,
//                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//               ),
//               onPressed: _isProcessingPayment ? null : _savedatapayment,
//               child: _isProcessingPayment
//                   ? CircularProgressIndicator()
//                   : Text(
//                       "Payment now",
//                       style: TextStyle(color: Colors.white),
//                     ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _savedatapayment() {
//     if (nameController.text.isEmpty ||
//         phoneController.text.isEmpty ||
//         addressController.text.isEmpty ||
//         emailController.text.isEmpty) {
//       Fluttertoast.showToast(
//         msg: 'Please fill all fields!',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.blue,
//         textColor: Colors.white,
//       );
//     } else {
//       setState(() {
//         _isProcessingPayment = true;
//       });
//
//       double price = widget.productModel.isSale
//           ? double.parse(widget.productModel.salePrice)
//           : double.parse(widget.productModel.fullPrice);
//       _openCheckout(price);
//     }
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shoppie/controllers/cart_price_controller.dart';
import 'package:shoppie/controllers/get_customer_device_token_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppie/models/product-model.dart';
import 'package:shoppie/views/utils/app-constant.dart';
import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';
import 'package:shoppie/views/widgets/singup_widgits.dart';
import '../../controllers/user_singler_order_controller.dart';

class SingleProductsOrders extends StatefulWidget {
  SingleProductsOrders({Key? key, required this.productModel});

  final ProductModel productModel;

  @override
  State<SingleProductsOrders> createState() => _SingleProductsOrdersState();
}

class _SingleProductsOrdersState extends State<SingleProductsOrders> {
  late String userId;
  bool _isEditing = false;

  void fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = userData['username'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['city'] ?? '';
          addressController.text = userData['email'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  late Razorpay _razorpay;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    fetchUserDetails();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful");
    Get.snackbar(
      "Orders Confirmed",
      "Thank you for your orders!",
      backgroundColor: AppConstant.appMainColor,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );

    Get.offAll(() => MainScreen());

    String customerToken = await getCustomerDeviceToken();
    SingleOrder(
        context: context,
        customerName: nameController.text,
        customerPhone: phoneController.text,
        customerAddress: addressController.text,
        customerDeviceToken: customerToken,
        customerEmail: emailController.text,
        quantity: 1,
        productModel: widget.productModel);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.message}");
    setState(() {
      _isProcessingPayment = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_JBkzkSNWNiCv41',
      'amount': (amount * 100).toInt(),
      'name': 'Shoppie',
      'description': 'Payment for products',
      'prefill': {
        'contact': phoneController.text,
        'email': emailController.text,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var view = AddCustomer(context: context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Order',
          style: TextStyle(color: AppConstant.appTextColor),
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productModel.productName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:widget.productModel.productImages[0] ,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        placeholder: (context, url) => CupertinoActivityIndicator(),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Price: ${widget.productModel.isSale ? widget.productModel.salePrice : widget.productModel.fullPrice}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            view.fieldView(
              controller: nameController,
              text: "Name",
              icon: CupertinoIcons.person,
              type: TextInputType.text,
              enabled: _isEditing,
            ),

            view.fieldView(
              controller: phoneController,
              text: "Phone",
              icon: CupertinoIcons.phone,
              type: TextInputType.phone,
              enabled: _isEditing,
            ),

            view.fieldView(
              controller: emailController,
              text: "Email",
              icon: Icons.email,
              type: TextInputType.emailAddress,
              enabled: _isEditing,
            ),

            view.fieldView(
              controller: addressController,
              text: "Address",
              icon: CupertinoIcons.home,
              type: TextInputType.text,
              enabled: _isEditing,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 290,bottom: 20),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(_isEditing ? Icons.done : Icons.edit,color: Colors.white,),
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.appMainColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _isProcessingPayment ? null : _savedatapayment,
              child: _isProcessingPayment
                  ? CircularProgressIndicator()
                  : Text(
                "Proceed to Payment",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _savedatapayment() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill all fields!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } else {
      setState(() {
        _isProcessingPayment = true;
      });

      double price = widget.productModel.isSale
          ? double.parse(widget.productModel.salePrice)
          : double.parse(widget.productModel.fullPrice);
      _openCheckout(price);
    }
  }
}

