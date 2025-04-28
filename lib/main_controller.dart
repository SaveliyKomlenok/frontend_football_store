import 'package:flutter/material.dart';
import 'package:frontend_football_store/pages/cart_page.dart';
import 'package:frontend_football_store/pages/clothes_page.dart';
import 'package:frontend_football_store/pages/custom_app_bar.dart';
import 'package:frontend_football_store/pages/main_page.dart';
import 'package:frontend_football_store/pages/profile_page.dart';
import 'package:frontend_football_store/pages/shoes_page.dart';



class MainController extends StatefulWidget {
  const MainController({super.key});

  @override
  State<MainController> createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const MainPage(),
    const ClothesPage(),
    const ShoesPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onMenuTap: _selectPage),
      body: _pages[_selectedPage],
    );
  }
}
