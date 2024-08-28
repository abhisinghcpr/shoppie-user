import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shoppie/views/screens/single_user_products_order.dart';
import '../../models/product-model.dart';
import '../utils/app-constant.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  ProductDetailsScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late User? user;
  bool isInCart = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkProductExistence();
    fetchCartItemCount();
    checkFavoriteExistence();
  }

  int cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstant.appTextColor),
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            "Product Details",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                height: 300,
                width: 220,
                child: CachedNetworkImage(
                  imageUrl: widget.productModel.productImages[0],
                  placeholder: (context, url) =>
                      Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // toggleFavorite();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.productModel.productName,
                                ),
                                // Icon(
                                //     isFavorite
                                //         ? Icons.favorite
                                //         : Icons.favorite_border,
                                //     color: Colors.red,
                                //     size: 35),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Rupees: " +
                                (widget.productModel.isSale
                                    ? widget.productModel.salePrice
                                    : widget.productModel.fullPrice),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Category: " + widget.productModel.categoryName,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.productModel.productDescription,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  String deepLink =
                                      'https://shoppingecommerce.page.link/shoppie/${widget.productModel.productId}';
                                  String message =
                                      '${widget.productModel.productName}\nPrice: ${widget.productModel.isSale ? widget.productModel.salePrice : widget.productModel.fullPrice}\n$deepLink';
                                  Share.share(message);
                                },
                                icon: Icon(Icons.share),
                                color: Colors.blue),
                            SizedBox(width: 2),

                            // Button(onPressed: () {
                            //   isInCart ? removeFromCart() : addToCart();
                            // }, buttonText: isInCart ? "Go to Cart" : "Add to Cart",
                            //
                            //            )
                            IconButton(
                              onPressed: () {
                                addFavorite();
                              },
                              icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 35),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Card(
          elevation: 10,
          color: Colors.white38,
          child: Container(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 170,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: TextButton(
                    child: Text(
                      isInCart ? "Go to Cart" : "Add to Cart",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      isInCart ? removeFromCart() : addToCart();
                    },
                  ),
                ),
                Container(
                  width: 170,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleProductsOrders(
                                productModel: widget.productModel),
                          ));
                    },
                    child: Text(
                      "Buy Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> checkProductExistence() async {
    if (user == null) return;

    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(widget.productModel.productId.toString())
          .get();

      setState(() {
        isInCart = snapshot.exists;
      });
    } catch (e) {
      print("Error checking product existence: $e");
    }
  }

  Future<void> addToCart() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(widget.productModel.productId.toString())
          .set(
        {
          'productQuantity': 1,
          'productTotalPrice': double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice),
          ...widget.productModel.toMap(),
        },
      );

      setState(() {
        isInCart = true;
      });

      Fluttertoast.showToast(
        msg: "added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> removeFromCart() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(widget.productModel.productId.toString())
          .delete();

      setState(() {
        isInCart = false;
      });

      Fluttertoast.showToast(
        msg: "Remove to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  Future<void> fetchCartItemCount() async {
    if (user == null) return;

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .get();

      setState(() {
        cartItemCount = querySnapshot.size;
      });
    } catch (e) {
      print("Error fetching cart item count: $e");
    }
  }

  void addFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (user != null) {
      if (isFavorite) {
        FirebaseFirestore.instance
            .collection('favorites')
            .doc(user!.uid)
            .collection('favoriteProducts')
            .doc(widget.productModel.productId.toString())
            .set(
              widget.productModel.toMap(),
            );
        Fluttertoast.showToast(
          msg: " added to Favorite",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        FirebaseFirestore.instance
            .collection('favorites')
            .doc(user!.uid)
            .collection('favoriteProducts')
            .doc(widget.productModel.productId.toString())
            .delete();
        Fluttertoast.showToast(
          msg: " Remove to Favorite",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  Future<void> checkFavoriteExistence() async {
    if (user == null) return;

    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user!.uid)
          .collection('favoriteProducts')
          .doc(widget.productModel.productId.toString())
          .get();

      setState(() {
        isFavorite = snapshot.exists;
      });
    } catch (e) {
      print("Error checking favorite existence: $e");
      // Handle error appropriately
    }
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shoppie/views/utils/app-constant.dart';
// import '../../controllers/products_details_controller.dart';
// import '../../models/product-model.dart';
// import 'single_user_products_order.dart';
//
// class ProductDetailsScreen extends StatelessWidget {
//   final ProductDetailsController controller = Get.put(ProductDetailsController());
//   final ProductModel productModel;
//
//   ProductDetailsScreen({Key? key, required this.productModel}) : super(key: key) {
//     controller.setProduct(productModel);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppConstant.appTextColor),
//         backgroundColor: AppConstant.appMainColor,
//         title: Text("Product Details"),
//       ),
//       body: GetBuilder<ProductDetailsController>(
//         builder: (_) {
//           return ListView(
//             children: [
//               SizedBox(height: 15),
//               Container(
//                 height: 300,
//                 width: 220,
//                 child: CachedNetworkImage(
//                   imageUrl: controller.productModel.productImages[0],
//                   placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 5.0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           // Your logic here
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             alignment: Alignment.topLeft,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   controller.productModel.productName,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             "Rupees: " +
//                                 (controller.productModel.isSale
//                                     ? controller.productModel.salePrice
//                                     : controller.productModel.fullPrice),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             "Category: " + controller.productModel.categoryName,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             controller.productModel.productDescription,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 String deepLink =
//                                     'https://shoppingecommerce.page.link/shoppie/${controller.productModel.productId}';
//                                 String message =
//                                     '${controller.productModel.productName}\nPrice: ${controller.productModel.isSale ? controller.productModel.salePrice : controller.productModel.fullPrice}\n$deepLink';
//                                 Share.share(message);
//                               },
//                               icon: Icon(Icons.share),
//                               color: Colors.blue,
//                             ),
//                             SizedBox(width: 2),
//                             IconButton(
//                               onPressed: () {
//                                 controller.addFavorite();
//                               },
//                               icon: Icon(
//                                 controller.isFavorite ? Icons.favorite : Icons.favorite_border,
//                                 color: Colors.red,
//                                 size: 35,
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//       bottomNavigationBar: Card(
//         elevation: 10,
//         color: Colors.white38,
//         child: Container(
//           height: 55,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 width: 170,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(7.0),
//                 ),
//                 child: TextButton(
//                   child: Text(
//                     controller.isInCart ? "Remove from Cart" : "Add to Cart",
//                     style: TextStyle(color: AppConstant.appTextColor),
//                   ),
//                   onPressed: () {
//                     if (controller.isInCart) {
//                       controller.removeFromCart();
//                     } else {
//                       controller.addToCart();
//                     }
//                   },
//                 ),
//               ),
//               Container(
//                 width: 170,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(7.0),
//                 ),
//                 child: TextButton(
//                   onPressed: () {
//                     Get.to(SingleProductsOrders(productModel: controller.productModel));
//                   },
//                   child: Text(
//                     "Buy Now",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
