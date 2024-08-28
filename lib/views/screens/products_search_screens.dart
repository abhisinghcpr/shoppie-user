import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shoppie/views/widgets/singup_widgits.dart';
import '../../models/product-model.dart';
import 'package:image_card/image_card.dart';

import 'product_deatils_screen.dart';



class SearchProductScreens extends StatefulWidget {
  const SearchProductScreens({Key? key}) : super(key: key);

  @override
  _SearchProductScreensState createState() => _SearchProductScreensState();
}

class _SearchProductScreensState extends State<SearchProductScreens> {
  late TextEditingController _searchController;
  List<DocumentSnapshot> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _products = snapshot.docs;
      _isLoading = false;
    });
  }

  List<DocumentSnapshot> get filteredProducts {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return _products;
    } else {
      return _products.where((product) {
        String productName = product['productName'].toString().toLowerCase();
        return productName.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var view = AddCustomer(context: context);
    return Scaffold(
      appBar: AppBar(
          title: view.fieldView(
              controller: _searchController,
              text: "Searching Product...",
              icon: Icons.search,
              type: TextInputType.text)),
      body: _isLoading
          ? Center(child: CupertinoActivityIndicator())
          : filteredProducts.isEmpty
          ? Center(
        child: Text('No products found.'),
      )
          : GridView.builder(
        itemCount: filteredProducts.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.80,
        ),
        itemBuilder: (context, index) {
          final productData = filteredProducts[index];
          ProductModel productModel = ProductModel(
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
          );
          return GestureDetector(
            onTap: () => Get.to(() => ProductDetailsScreen(
                productModel: productModel)),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.blue, width: 2.0),
                ),
                child: FillImageCard(
                  borderRadius: 20.0,
                  width: Get.width / 2.3,
                  heightImage: Get.height / 6,
                  imageProvider: CachedNetworkImageProvider(
                    productModel.productImages[0],
                    errorListener: (p0) => Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                  title: Center(
                    child: Text(
                      productModel.productName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  footer: Center(
                    child: Text(
                        "Rupees: " + productModel.fullPrice),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
