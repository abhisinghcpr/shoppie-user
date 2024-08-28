import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppie/views/utils/app-constant.dart';

import '../../models/user-model.dart';
import '../widgets/singup_widgits.dart';


class UpdateUserScreen extends StatefulWidget {
  final UserModel userData;

  const UpdateUserScreen({required this.userData, Key? key}) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData.username);
    _emailController = TextEditingController(text: widget.userData.email);
    _phoneController = TextEditingController(text: widget.userData.phone);
    _cityController = TextEditingController(text: widget.userData.city);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.uId)
          .update({
        'username': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'city': _cityController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User Details updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Not updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var view = AddCustomer(context: context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Update Profile',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              view.fieldView(
                  text1: "Name",
                  icon: Icons.person,
                  type: TextInputType.text,
                  controller: _nameController),
              view.fieldView(
                  text1: "Email",
                  icon: Icons.email,
                  type: TextInputType.text,
                  controller: _emailController),
              view.fieldView(
                  text1: "Phone",
                  icon: Icons.phone,
                  type: TextInputType.number,
                  controller: _phoneController),
              view.fieldView(
                  text1: "City",
                  icon: Icons.home,
                  type: TextInputType.text,
                  controller: _cityController),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: _updateUserData,
                child: Text('Saved Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
