import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppie/models/user-model.dart';
import 'package:shoppie/views/screens/all-_categories_screen.dart';



import '../auth-ui/Intro_screen.dart';
import '../screens/all_products_orders_screen.dart';
import '../screens/all_products_screen.dart';
import '../screens/user_contact_us_screen.dart';
import '../utils/app-constant.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late UserModel userData = UserModel(
      username: '',
      email: '',
      uId: '',
      phone: '',
      userImg: '',
      userDeviceToken: '',
    //  createdOn: null,
      city: '');

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        userData =
            UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
        setState(() {});
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        )),
        backgroundColor: AppConstant.appScendoryColor,
        child: Container(
          color: AppConstant.appMainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: 400,
                color: Colors.blue,
                padding: EdgeInsets.all(15),
                // Background color of the header
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: userData.userImg,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                          )),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userData.username,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      userData.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  title: Text(
                    'Categories',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.category,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Get.back();
                    Get.to(() => AllCategoriesScreen());
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  title: Text(
                    'Products',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.production_quantity_limits,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Get.back();
                    Get.to(() => AllProductsScreen());
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  title: Text(
                    'Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Get.back();
                    Get.to(() => AllOrdersScreen());
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  title: Text(
                    'Contact',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.help,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Get.to(() => ContactUsPage());
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signOut();
                    await googleSignIn.signOut();
                    Get.offAll(() => IntroPage());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
