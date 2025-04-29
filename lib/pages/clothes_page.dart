import 'package:flutter/material.dart';
import 'package:frontend_football_store/cards/cloth_card.dart';

class ClothesPage extends StatelessWidget {
  final Function(int) onMenuTap;

  const ClothesPage({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (screenWidth < 1200) crossAxisCount = 3;
    if (screenWidth < 800) crossAxisCount = 2;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GridView.builder(
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return ClothCard(
            title: 'Товар ${index + 1}',
            price: 5000 + index * 300,
            imageUrl: 'https://via.placeholder.com/300x400',
            onPressed: () => onMenuTap(5), // Navigate to ClothingInfoPage
          );
        },
      ),
    );
  }
}