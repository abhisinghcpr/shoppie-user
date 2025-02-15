import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shoppie/controllers/cart_price_controller.dart';
import 'package:shoppie/views/utils/app-constant.dart';
import 'package:shoppie/views/widgets/buttomnavigation_widgets.dart';
import 'package:shoppie/views/widgets/singup_widgits.dart';
import '../../controllers/get_customer_device_token_controller.dart';
import '../../controllers/services/place-order-service.dart';
import '../../models/cart-model.dart';


class UserProductOrderScreen extends StatefulWidget {
  const UserProductOrderScreen({Key? key}) : super(key: key);

  @override
  State<UserProductOrderScreen> createState() => _UserProductOrderScreenState();
}

class _UserProductOrderScreenState extends State<UserProductOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  late Razorpay _razorpay;

  late String userId;

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
          addressController.text = userData['city'] ?? '';
          emailController.text = userData['email'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

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
    EasyLoading.dismiss();
    String customerToken = await getCustomerDeviceToken();
    placeOrder(
      context: context,
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,
      customerDeviceToken: customerToken,
      customerEmail: emailController.text,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void _openCheckout(double amount) async {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Order ',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                  );

                  productPriceController.fetchProductPrice();
                  return Container(
                    key: ObjectKey(cartModel.productId),
                    child: GestureDetector(
                      onTap: () async {
                        _showDeleteConfirmationDialog(
                            context, cartModel.productId);
                      },
                      child: Card(
                        elevation: 5,
                        color: AppConstant.appTextColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appMainColor,
                            backgroundImage:
                            NetworkImage(cartModel.productImages[0]),
                          ),
                          title: Text(cartModel.productName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(cartModel.productTotalPrice.toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              _showDeleteConfirmationDialog(
                                  context, cartModel.productId);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () =>
                  Text(
                    " Total R - ${productPriceController.totalPrice.value
                        .toStringAsFixed(1)} ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Confirm Order",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      showCustomBottomSheet();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('cart')
                    .doc(user!.uid)
                    .collection('cartOrders')
                    .doc(productId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void showCustomBottomSheet() {
    var view = AddCustomer(context: context);
    Get.bottomSheet(
      Center(
        child: Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 37,
                ),
                view.fieldView(
                    controller: nameController,
                    text: "Name",
                    icon: CupertinoIcons.person,
                    type: TextInputType.text),
                view.fieldView(
                    controller: phoneController,
                    text: "Phone",
                    icon: CupertinoIcons.phone,
                    type: TextInputType.phone),
                view.fieldView(
                    controller: emailController,
                    text: "Email",
                    icon: Icons.email,
                    type: TextInputType.emailAddress),
                view.fieldView(
                    controller: addressController,
                    text: "Address",
                    icon: CupertinoIcons.home,
                    type: TextInputType.text),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  onPressed: () {
                    _savedatapayment(context);
                  },
                  child: Text(
                    "Payment now",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }

  void _savedatapayment(BuildContext context) async {
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      );


      try {
        _openCheckout(productPriceController.totalPrice.value);
      } catch (e) {
        print("Payment Error: $e");
        Navigator.pop(context);
      }
    }
  }





}
