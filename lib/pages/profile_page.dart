import 'package:flutter/material.dart';
import 'package:frontend_football_store/main_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) onMenuTap;
  const ProfilePage({super.key,required this.onMenuTap});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = 'Имя пользователя';
  String email = 'example@mail.com';
  String phone = '+123 456 7890';
  String avatarUrl = 'https://example.com/user-avatar.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Центрирование по горизонтали
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50, // Радиус круга
              backgroundImage: NetworkImage(avatarUrl), // URL аватара
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              phone, // Пример телефона
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Логика редактирования профиля
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Синий цвет кнопки
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Отступы вокруг текста
              ),
              child: const Text('Редактировать профиль', style: TextStyle(color: Colors.white)), // Цвет текста
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                widget.onMenuTap(7);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Синий цвет кнопки
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Отступы вокруг текста
              ),
              child: const Text('Заказы', style: TextStyle(color: Colors.white)), // Цвет текста
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                prefs.remove('role');
                prefs.remove('username');
                // Логика выхода из профиля
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainController()),
                ); // Вернуться на предыдущую страницу
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Красный цвет кнопки выхода
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Отступы вокруг текста
              ),
              child: const Text('Выйти', style: TextStyle(color: Colors.white)), // Цвет текста
            ),
          ],
        ),
      ),
    );
  }
}