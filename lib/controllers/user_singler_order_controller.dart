import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:shoppie/models/product-model.dart';
import '../models/order-model.dart';
import 'services/genrate-order-id-service.dart';



void SingleOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerEmail,
  required String customerDeviceToken,
  required int quantity,
  required ProductModel productModel,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      var orderModel = OrderModel(
        productId: productModel.productId,
        categoryId: productModel.categoryId,
        productName: productModel.productName,
        categoryName: productModel.categoryName,
        salePrice: productModel.salePrice,
        fullPrice: productModel.fullPrice,
        productImages: productModel.productImages,
        deliveryTime: productModel.deliveryTime,
        isSale: productModel.isSale,
        productDescription: productModel.productDescription,
        createdAt: productModel.createdAt,
        updatedAt: productModel.updatedAt,
        productQuantity: quantity,
        productTotalPrice: double.parse(productModel.fullPrice),
        customerId: user.uid,
        status: false,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        customerEmail: customerEmail,
        customerDeviceToken: customerDeviceToken,
      );
      String orderId = generateOrderId();

      // Upload order details
      await FirebaseFirestore.instance.collection('orders').doc(user.uid).set({
        'uId': user.uid,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'customerEmail': customerEmail,
        'customerDeviceToken': customerDeviceToken,
        'orderStatus': false,
        'createdAt': DateTime.now()
      });


      // Upload order model
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(user.uid)
          .collection('confirmOrders')
          .doc(orderId)
          .set(orderModel.toMap());


    } catch (e) {
      print("Error: $e");
      EasyLoading.dismiss();
    }
  }
}
