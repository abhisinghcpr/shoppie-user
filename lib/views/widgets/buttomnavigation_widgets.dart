
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppie/views/screens/main_screen.dart';
import 'package:shoppie/views/screens/products_search_screens.dart';
import '../auth-ui/user_profile_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/my_favrouits_page.dart';
import '../utils/app-constant.dart';
import 'custom-drawer-widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MainScreenContent(),
    SearchProductScreens(),
    CartScreen(),
    ProfileScreens(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,

        title: Text(
          AppConstant.appMainName,
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        elevation: 5,
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage()),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, size: 30,color: Colors.white,),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.search_circle_fill),
            icon: Icon(
              CupertinoIcons.search_circle,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.cart_fill),
            icon: Icon(
              CupertinoIcons.cart,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
            ),
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        elevation: 10,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
