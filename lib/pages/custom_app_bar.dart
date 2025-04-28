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
              const SizedBox(width: 30),
              _buildAuthButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        _showAuthDialog(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.person, color: Colors.white, size: 25),
          SizedBox(height: 4), // Отступ между иконкой и текстом
          Text('Авторизация', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

void _showAuthDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Белый фон
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Выравнивание по левому краю
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0), // Отступ справа
              child: Text('Авторизация', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Spacer(), // Добавляем Spacer для отделения крестика
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(16.0), // Увеличенные отступы
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300, // Задайте желаемую ширину
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    labelStyle: const TextStyle(color: Colors.black), // Синий цвет текста
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки по умолчанию
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки при обычном состоянии
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы при фокусе
                      borderSide: const BorderSide(color: Colors.blue, width: 2), // Синий цвет обводки при фокусе
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 300, // Задайте желаемую ширину
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: const TextStyle(color: Colors.black), // Синий цвет текста
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки по умолчанию
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки при обычном состоянии
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы при фокусе
                      borderSide: const BorderSide(color: Colors.blue, width: 2), // Синий цвет обводки при фокусе
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Здесь вы можете добавить логику для обработки авторизации
                  Navigator.of(context).pop(); // Закрыть диалог
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Синий цвет фона
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Закругленные края
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), // Отступы вокруг текста
                ),
                child: const Text('Войти', style: TextStyle(fontSize: 16)), // Размер шрифта
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Закрыть авторизацию
                  _showRegisterDialog(context); // Показать диалог регистрации
                },
                child: const Text('Нет аккаунта? Зарегистрируйтесь', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  void _showRegisterDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Белый фон
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0), // Отступ слева
              child: Text('Регистрация', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Spacer(), // Добавляем Spacer для отделения крестика
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(16.0), // Увеличенные отступы
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300, // Задайте желаемую ширину
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    labelStyle: const TextStyle(color: Colors.black), // Цвет текста метки
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки по умолчанию
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки при обычном состоянии
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы при фокусе
                      borderSide: const BorderSide(color: Colors.blue, width: 2), // Синий цвет обводки при фокусе
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 300, // Задайте желаемую ширину
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: const TextStyle(color: Colors.black), // Цвет текста метки
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки по умолчанию
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы
                      borderSide: const BorderSide(color: Colors.blue), // Синий цвет обводки при обычном состоянии
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Закругленные углы при фокусе
                      borderSide: const BorderSide(color: Colors.blue, width: 2), // Синий цвет обводки при фокусе
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Здесь вы можете добавить логику для обработки регистрации
                  Navigator.of(context).pop(); // Закрыть диалог
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Синий цвет фона
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Закругленные края
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), // Отступы вокруг текста
                ),
                child: const Text('Регистрация', style: TextStyle(fontSize: 16)), // Размер шрифта
              ),
            ],
          ),
        ),
      );
    },
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 25),
          const SizedBox(height: 4), // Отступ между иконкой и текстом
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}