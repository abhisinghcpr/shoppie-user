import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  int _cartItemCount = 0;

  int get cartItemCount => _cartItemCount;

  void updateCartItemCount(int count) {
    _cartItemCount = count;
    notifyListeners();
  }
}
