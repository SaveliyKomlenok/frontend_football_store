import 'package:flutter/material.dart';

class ShoesInfoPage extends StatelessWidget {
  const ShoesInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Подробная информация об обуви',
        style: TextStyle(fontSize: 24, color: Colors.grey[700]),
      ),
    );
  }
}