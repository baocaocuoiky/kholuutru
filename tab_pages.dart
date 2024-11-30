import 'package:flutter/material.dart';
import 'package:shoe_store/view/cart_page.dart';
import 'package:shoe_store/view/home.dart';
import 'package:shoe_store/view/profile_page.dart';
class TabPages extends StatefulWidget {
  const TabPages({super.key});

  @override
  State<TabPages> createState() => _State();
}

class _State extends State<TabPages> {
  int currentIndex = 0;
  void onNextTab(int index){
    setState(() {
      currentIndex = index;
    });
  }
  final List<Widget> pages = [
    Home(),
    CartPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNextTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, size: 30), label: "giỏ hàng"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: "Hồ sơ")
        ],
      ),
    );
  }
}
