import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onMenuTap;

  const CustomAppBar({super.key, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(70); // Высота AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 0, 140, 255),
      foregroundColor: Colors.black,
      toolbarHeight: 100,
      title: Row(
        
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.sports_soccer, color: Colors.deepPurple),
          const SizedBox(width: 10),
          const Text(
            'M.O.drid shop',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          const SizedBox(height: 10),
          // Кнопки с иконками над ними, расположенные горизонтально
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildButton(Icons.home, 'Главная', 0),
              const SizedBox(width: 30),
              _buildSvgButton('lib/images/soccer-player-striped-t-shirt-svgrepo-com.svg', 'Одежда', 1),
              const SizedBox(width: 30),
              _buildSvgButton('lib/images/football-shoe-svgrepo-com.svg', 'Обувь', 2),
              const SizedBox(width: 30),
              _buildButton(Icons.shopping_cart, 'Корзина', 3),
              const SizedBox(width: 30),
              _buildButton(Icons.person, 'Профиль', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSvgButton(String assetPath, String label, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => onMenuTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,  // Центрируем по вертикали
        children: [
          SvgPicture.asset(
            assetPath,
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          const SizedBox(height: 4), // Отступ между иконкой и текстом
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => onMenuTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,  // Центрируем по вертикали
        children: [
          Icon(icon, color: Colors.white, size: 25,),
          const SizedBox(height: 4), // Отступ между иконкой и текстом
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}