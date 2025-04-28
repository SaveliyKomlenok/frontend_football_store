import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Корзина пуста',
        style: TextStyle(fontSize: 24, color: Colors.grey[700]),
      ),
    );
  }
}