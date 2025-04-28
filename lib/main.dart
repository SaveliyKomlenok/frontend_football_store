import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football Store',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const ProductsPage(),
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

// --- Шапка сайта с рабочими кнопками ---
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onMenuTap;

  const CustomAppBar({super.key, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: Row(
        children: [
          const Icon(Icons.sports_soccer, color: Colors.green),
          const SizedBox(width: 10),
          const Text(
            'Football Store',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => onMenuTap(0),
            child: const Text('Главная', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => onMenuTap(1),
            child: const Text('Корзина', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => onMenuTap(2),
            child: const Text('Профиль', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

// --- Страница товаров ---
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

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
          return ProductCard(
            title: 'Товар ${index + 1}',
            price: 5000 + index * 300,
            imageUrl: 'https://via.placeholder.com/300x400',
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

// --- Страница корзины ---
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

// --- Страница профиля ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Профиль пользователя',
        style: TextStyle(fontSize: 24, color: Colors.grey[700]),
      ),
    );
  }
}
