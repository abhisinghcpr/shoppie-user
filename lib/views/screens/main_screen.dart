import 'package:flutter/material.dart';
import 'package:shoppie/views/widgets/all-products-widget.dart';
import 'package:shoppie/views/widgets/banner_widget.dart';
import 'package:shoppie/views/widgets/category_widget.dart';
import 'package:shoppie/views/widgets/heading_widget.dart';
import 'package:shoppie/views/widgets/sale_widget.dart';
import 'all-_categories_screen.dart';
import 'all_flash_sale_products.dart';
import 'all_products_screen.dart';

class MainScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        // Implement your refresh logic here
        return Future.delayed(Duration(seconds: 1));
      },
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 90.0,
              ),
              //banners

              HeadingWidget(
                headingTitle: "Categories",
                headingSubTitle: "According to your Rupees",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllCategoriesScreen())),
              ),
              CategoriesWidget(),

              HeadingWidget(
                headingTitle: "Maha Bachat Deals 😎😳",
                // headingSubTitle: "All Sales",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AllFlashSaleProductScreen())),
              ),

              FlashSaleWidget(),

              HeadingWidget(
                headingTitle: "All Products",
                //headingSubTitle: "According to your budget",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllProductsScreen())),
              ),

              AllProductsWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
