import 'package:flutter/material.dart';

class ClothCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;
  final VoidCallback onPressed; // Add this line

  const ClothCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.onPressed, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector to handle taps
      onTap: onPressed, // Call the onPressed callback
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$price ₽',
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}