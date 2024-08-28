import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app-constant.dart';

class AddCustomer {
  BuildContext context;

  AddCustomer({required this.context});

  Widget fieldView({
       TextEditingController? controller,  String? text,  String? text1,
    required IconData icon,required TextInputType type ,   bool?  enabled,}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          cursorColor: AppConstant.appScendoryColor,
          keyboardType: type,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: text,
            labelText: text1,

            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
