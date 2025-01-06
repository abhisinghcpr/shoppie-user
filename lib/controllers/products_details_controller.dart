import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/product-model.dart';

class ProductDetailsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? user;
  bool isInCart = false;
  bool isFavorite = false;
  late ProductModel productModel;

  @override
  void onInit() {
    super.onInit();
    user = _auth.currentUser;
    checkProductExistence();
    checkFavoriteExistence();
  }

  void setProduct(ProductModel product) {
    productModel = product;
  }

  Future<void> checkProductExistence() async {
    if (user == null) return;

    try {
      final DocumentSnapshot snapshot = await _firestore
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(productModel.productId.toString())
          .get();

      isInCart = snapshot.exists;
      update();
    } catch (e) {
      print("Error checking product existence: $e");
    }
  }

  Future<void> addToCart() async {
    if (user == null) return;

    try {
      await _firestore
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(productModel.productId.toString())
          .set(
        {
          'productQuantity': 1,
          'productTotalPrice': double.parse(productModel.isSale
              ? productModel.salePrice
              : productModel.fullPrice),
          ...productModel.toMap(),
        },
      );

      isInCart = true;
      Fluttertoast.showToast(
        msg: "Added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      update();
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> removeFromCart() async {
    if (user == null) return;

    try {
      await _firestore
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(productModel.productId.toString())
          .delete();

      isInCart = false;
      Fluttertoast.showToast(
        msg: "Remove to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      update();
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  void addFavorite() async {
    isFavorite = !isFavorite;
    update();

    if (user != null) {
      try {
        if (isFavorite) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(user!.uid)
              .collection('favoriteProducts')
              .doc(productModel.productId.toString())
              .set(
                productModel.toMap(),
              );
          Fluttertoast.showToast(
            msg: "Add to Favorite",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(user!.uid)
              .collection('favoriteProducts')
              .doc(productModel.productId.toString())
              .delete();
        }
      } catch (e) {
        print("Error adding/removing from favorites: $e");
      }
    }
  }

  Future<void> checkFavoriteExistence() async {
    if (user == null) return;

    try {
      final DocumentSnapshot snapshot = await _firestore
          .collection('favorites')
          .doc(user!.uid)
          .collection('favoriteProducts')
          .doc(productModel.productId.toString())
          .get();

      isFavorite = snapshot.exists;
      update();
    } catch (e) {
      print("Error checking favorite existence: $e");
    }
  }

}
