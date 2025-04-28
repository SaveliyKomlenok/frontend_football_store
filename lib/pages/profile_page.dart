import 'package:flutter/material.dart';
import 'package:frontend_football_store/main_controller.dart';
import 'package:frontend_football_store/pages/main_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center, // Центрирование по горизонтали
          children: [
            const SizedBox(height: 20,),
            CircleAvatar(
              radius: 50, // Радиус круга
              backgroundImage: NetworkImage('https://example.com/user-avatar.png'), // Замените на URL аватара
            ),
            const SizedBox(height: 16),
            const Text(
              'Имя пользователя',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'example@mail.com',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              '+123 456 7890', // Пример телефона
              style: TextStyle(fontSize: 18, color: Colors.grey),
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
                // Логика выхода из профиля
               Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainController()),
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