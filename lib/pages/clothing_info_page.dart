import 'package:flutter/material.dart';

class ClothingInfoPage extends StatelessWidget {
  const ClothingInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Подробная информация об одежде',
        style: TextStyle(fontSize: 24, color: Colors.grey[700]),
      ),
    );
  }
}