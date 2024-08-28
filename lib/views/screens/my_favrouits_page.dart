import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shoppie/views/utils/app-constant.dart';
import '../../../models/product-model.dart';


class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late User? user;
  List<ProductModel> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchFavoriteProducts();
  }

  Future<void> fetchFavoriteProducts() async {
    if (user == null) return;

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favoriteProducts')
        .get();

    final List<ProductModel> products = [];
    querySnapshot.docs.forEach((doc) {
      final product = ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      products.add(product);
    });

    setState(() {
      favoriteProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Favorite Page",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: favoriteProducts.isEmpty
          ? Center(
        child: Text('No favorite products available.',style: TextStyle(color: Colors.red,fontSize: 20)),
      )
          : ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return Container(
            width: 150,
            height: 100,
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
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(

                        product.productImages[0],
                        )
                      ),
                    ),
                  ),
                  title: Text(
                    product.productName,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        product.fullPrice,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: Get.width / 10.0),
                      if (user != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm"),
                                    content: Text("Delete this item?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await removeFromFavorites(product);
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
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
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

  Future<void> removeFromFavorites(ProductModel product) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favoriteProducts')
        .doc(product.productId)
        .delete();
    fetchFavoriteProducts();
  }
}
