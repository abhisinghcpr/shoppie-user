import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppie/controllers/cart_price_controller.dart';
import 'package:shoppie/views/utils/app-constant.dart';
import '../../models/cart-model.dart';
import 'products_order_screen.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  bool isDataAvailable = false;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get()
        .then((value) {
      isDataAvailable = value.docs.length == 0 ? false : true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white70,
        title: Text('Cart Screen'),
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
            isDataAvailable = false;
            return Center(
              child: Text("No Cart products Available!",
                  style: TextStyle(fontSize: 18)),
            );
          } else {
            isDataAvailable = true;
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

                  // calculate price

                  productPriceController.fetchProductPrice();

                  return Container(
                    width: 150,
                    height: 100,
                    key: ObjectKey(cartModel.productId),
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appTextColor,
                      child: Center(
                        child: ListTile(
                          leading: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                fit: BoxFit.cover, // Adjust the fit as needed
                                image:CachedNetworkImageProvider(
                                    cartModel.productImages[0]
                                )


                              ),
                            ),
                          ),
                          title: Text(
                            cartModel.productName,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                cartModel.productTotalPrice.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: Get.width / 20.0),
                              GestureDetector(
                                onTap: () async {
                                  if (cartModel.productQuantity > 1) {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity':
                                          cartModel.productQuantity - 1,
                                      'productTotalPrice':
                                          (double.parse(cartModel.fullPrice) *
                                              (cartModel.productQuantity - 1))
                                    });
                                    setState(() {});
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width / 20.0),
                              GestureDetector(
                                onTap: () async {
                                  if (cartModel.productQuantity > 0) {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity':
                                          cartModel.productQuantity + 1,
                                      'productTotalPrice': double.parse(
                                              cartModel.fullPrice) +
                                          double.parse(cartModel.fullPrice) *
                                              (cartModel.productQuantity)
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width / 10.0),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Conform"),
                                        content: Text("Delete this item?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              print('deleted');
                                              await FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .doc(user!.uid)
                                                  .collection('cartOrders')
                                                  .doc(cartModel.productId)
                                                  .delete();
                                              if (snapshot.data!.docs.length ==
                                                  0) {
                                                isDataAvailable = false;
                                                setState(() {});
                                              }
                                            },
                                            child: Text("Delete"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.red,
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          // return Container();
        },
      ),
      bottomNavigationBar: isDataAvailable
          ? Visibility(
              visible: isDataAvailable,
              child: Card(
                elevation: 5,
                 child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                        () => Text(
                      " Total R- ${productPriceController.totalPrice.value.toStringAsFixed(1)} ",
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                          child: Text(
                            "Check Out",
                            style: TextStyle(color: AppConstant.appTextColor),
                          ),
                          onPressed: () {
                            Get.to(() => UserProductOrderScreen());
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            )
          : SizedBox(),
    );
  }
}
