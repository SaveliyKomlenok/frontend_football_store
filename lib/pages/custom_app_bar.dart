import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onMenuTap;

  const CustomAppBar({super.key, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(100); // Увеличиваем высоту

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: Row(
        children: [
          // Добавление мест для 3 картинок
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  'https://i.ytimg.com/vi/-xE6bGyuudI/maxresdefault.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  'https://i.ytimg.com/vi/-xE6bGyuudI/maxresdefault.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  'https://i.ytimg.com/vi/-xE6bGyuudI/maxresdefault.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Icon(Icons.sports_soccer, color: Colors.green),
          const SizedBox(width: 10),
          const Text(
            'M.O.drid shop',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Spacer(),
          // Кнопки с иконками над ними, расположенные горизонтально
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconButton(Icons.home, 'Главная', 0),
              _buildSvgButton('lib/images/soccer-player-striped-t-shirt-svgrepo-com.svg',  'Одежда', 1),
              _buildSvgButton('lib/images/football-shoe-svgrepo-com.svg', 'Обувь', 2),
              _buildIconButton(Icons.shopping_cart, 'Корзина', 3),
              _buildIconButton(Icons.person, 'Профиль', 4),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildSvgButton(String assetPath, String label, int index) {
    return Column(
      children: [
         SizedBox(width: 70,),
        IconButton(
          icon: SvgPicture.asset(
            assetPath,
            width: 24, // Установите нужный размер
            height: 24,
          ),
          onPressed: () => onMenuTap(index),
        ),
        Text(label, style: const TextStyle(color: Colors.black,fontSize: 12)),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String label, int index) {
    return Column(
      
      children: [
        SizedBox(width: 70,),
        IconButton(
          icon: Icon(icon, color: Colors.black),
          onPressed: () => onMenuTap(index),
        ),
        Text(label, style: const TextStyle(color: Colors.black,fontSize: 12)),
      ],
    );
  }
}