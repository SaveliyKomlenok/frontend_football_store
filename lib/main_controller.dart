import 'package:flutter/material.dart';
import 'package:frontend_football_store/pages/cart_page.dart';
import 'package:frontend_football_store/pages/clothes_page.dart';
import 'package:frontend_football_store/pages/clothing_info_page.dart';
import 'package:frontend_football_store/pages/custom_app_bar.dart';
import 'package:frontend_football_store/pages/main_page.dart';
import 'package:frontend_football_store/pages/profile_page.dart';
import 'package:frontend_football_store/pages/shoes_info_page.dart';
import 'package:frontend_football_store/pages/shoes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends StatefulWidget {
  const MainController({super.key});

  @override
  State<MainController> createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {
  int _selectedPage = 0;
  String? token;
  String? role;
  String? username;
  late SharedPreferences prefs;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    initSharedPref();
    _pages.addAll([
      const MainPage(),
      ClothesPage(onMenuTap: _selectPage),
      ShoesPage(onMenuTap: _selectPage),
      CartPage(),
      const ProfilePage(),
      const ClothingInfoPage(),
      const ShoesInfoPage()
    ]);
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      role = prefs.getString('role');
      username = prefs.getString('username');
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onMenuTap: _selectPage, token: token),
      body: _pages[_selectedPage],
    );
  }
}