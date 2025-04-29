import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_football_store/model/request/user_authenticate_request.dart';
import 'package:frontend_football_store/model/request/user_register_request.dart';
import 'package:frontend_football_store/service/authentication_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(int) onMenuTap;
  final String? token;

  const CustomAppBar({
    super.key,
    required this.onMenuTap,
    this.token,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70); // Высота AppBar
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildButton(Icons.home, 'Главная', 0),
              const SizedBox(width: 30),
              _buildSvgButton('lib/images/soccer-player-striped-t-shirt-svgrepo-com.svg', 'Одежда', 1),
              const SizedBox(width: 30),
              _buildSvgButton('lib/images/football-shoe-svgrepo-com.svg', 'Обувь', 2),
              if (widget.token != null) ...[
                const SizedBox(width: 30),
                _buildButton(Icons.shopping_cart, 'Корзина', 3),
                const SizedBox(width: 30),
                _buildButton(Icons.person, 'Профиль', 4),
              ],
              if (widget.token == null) ...[
                const SizedBox(width: 30),
                _buildAuthButton(context),
              ],
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
          SizedBox(height: 4),
          Text('Авторизация', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  void _showAuthDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isEmailEmpty = false;
    bool isPasswordEmpty = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Авторизация', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Имя пользователя',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isEmailEmpty ? Colors.red : Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isEmailEmpty ? Colors.red : Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isPasswordEmpty ? Colors.red : Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isPasswordEmpty ? Colors.red : Colors.blue),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEmailEmpty = emailController.text.isEmpty;
                      isPasswordEmpty = passwordController.text.isEmpty;
                    });

                    if (!isEmailEmpty && !isPasswordEmpty) {
                      final request = UserAuthenticateRequest(
                        username: emailController.text,
                        password: passwordController.text,
                      );
                      AuthenticationService.authenticate(request, context);
                     
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                  child: const Text('Войти', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRegisterDialog(context);
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
    final TextEditingController firstnameController = TextEditingController();
    final TextEditingController lastnameController = TextEditingController();
    bool isFirstnameEmpty = false;
    bool isLastnameEmpty = false;
    bool isEmailEmpty = false;
    bool isPasswordEmpty = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Регистрация', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isFirstnameEmpty ? Colors.red : Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isFirstnameEmpty ? Colors.red : Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 300,
                  child: TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      labelText: 'Фамилия',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isLastnameEmpty ? Colors.red : Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isLastnameEmpty ? Colors.red : Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Имя пользователя',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isEmailEmpty ? Colors.red : Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isEmailEmpty ? Colors.red : Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isPasswordEmpty ? Colors.red : Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: isPasswordEmpty ? Colors.red : Colors.blue),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFirstnameEmpty = firstnameController.text.isEmpty;
                      isLastnameEmpty = lastnameController.text.isEmpty;
                      isEmailEmpty = emailController.text.isEmpty;
                      isPasswordEmpty = passwordController.text.isEmpty;
                    });

                    if (!isFirstnameEmpty && !isLastnameEmpty && !isEmailEmpty && !isPasswordEmpty) {
                      final request = UserRegisterRequest(
                        username: emailController.text,
                        firstname: firstnameController.text,
                        lastname: lastnameController.text,
                        password: passwordController.text,
                      );
                      AuthenticationService().register(request, context);
                      
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                  child: const Text('Регистрация', style: TextStyle(fontSize: 16)),
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
      onPressed: () => widget.onMenuTap(index),
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
          const SizedBox(height: 4),
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
      onPressed: () => widget.onMenuTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 25),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}