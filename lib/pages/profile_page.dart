import 'package:flutter/material.dart';
import 'package:frontend_football_store/main_controller.dart';
import 'package:frontend_football_store/model/request/user_change_password_request.dart';
import 'package:frontend_football_store/model/request/user_edit_request.dart';
import 'package:frontend_football_store/model/user_response.dart';
import 'package:frontend_football_store/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) onMenuTap;
  const ProfilePage({super.key, required this.onMenuTap});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserResponse? user;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    UserResponse response = await userService.getProfile();
    setState(() {
      user = response;
    });
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('username');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainController()),
    );
  }

  void _showEditProfileDialog() {
    final firstnameController = TextEditingController(text: user?.firstname ?? '');
    final lastnameController = TextEditingController(text: user?.lastname ?? '');
    final usernameController = TextEditingController(text: user?.username ?? '');

    bool firstError = false;
    bool lastError = false;
    bool userError = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
              titlePadding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Редактировать профиль', style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      border: const OutlineInputBorder(),
                      errorText: firstError ? 'Поле не может быть пустым' : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      labelText: 'Фамилия',
                      border: const OutlineInputBorder(),
                      errorText: lastError ? 'Поле не может быть пустым' : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Имя пользователя',
                      border: const OutlineInputBorder(),
                      errorText: userError ? 'Поле не может быть пустым' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      ),
                      child: const Text('Подтвердить', style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        setState(() {
                          firstError = firstnameController.text.isEmpty;
                          lastError = lastnameController.text.isEmpty;
                          userError = usernameController.text.isEmpty;
                        });

                        if (firstError || lastError || userError) return;

                        final isModified = firstnameController.text != user!.firstname ||
                            lastnameController.text != user!.lastname ||
                            usernameController.text != user!.username;

                        if (!isModified) {
                          Navigator.pop(context);
                          return;
                        }

                        try {
                          await userService.updateProfile(UserEditRequest(
                            firstname: firstnameController.text,
                            lastname: lastnameController.text,
                            username: usernameController.text,
                          ));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Профиль обновлён. Пожалуйста, войдите заново.'),
                            ),
                          );
                          await logout();
                        } catch (e) {
                          showErrorSnackbar("Ошибка при обновлении профиля");
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    bool passError = false;
    bool confirmError = false;
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
              titlePadding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Изменить пароль', style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Новый пароль',
                      border: const OutlineInputBorder(),
                      errorText: passError ? errorText : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Подтвердите пароль',
                      border: const OutlineInputBorder(),
                      errorText: confirmError ? errorText : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      ),
                      child: const Text('Подтвердить', style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        setState(() {
                          passError = false;
                          confirmError = false;
                          errorText = null;
                        });

                        final password = passwordController.text;
                        final confirm = confirmController.text;

                        if (password.isEmpty || confirm.isEmpty) {
                          setState(() {
                            passError = password.isEmpty;
                            confirmError = confirm.isEmpty;
                            errorText = 'Поле не может быть пустым';
                          });
                          return;
                        }

                        if (password.length < 6) {
                          setState(() {
                            passError = true;
                            errorText = 'Пароль должен быть не менее 6 символов';
                          });
                          return;
                        }

                        if (password != confirm) {
                          setState(() {
                            confirmError = true;
                            errorText = 'Пароли не совпадают';
                          });
                          return;
                        }

                        try {
                          await userService.changePassword(
                              UserChangePasswordRequest(password: password));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Пароль изменён. Пожалуйста, войдите заново.'),
                              backgroundColor: Colors.indigo,
                            ),
                          );
                          await logout();
                        } catch (e) {
                          showErrorSnackbar("Ошибка при изменении пароля");
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCompactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 160,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: user == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blueAccent,
                                child: Icon(Icons.person, size: 50, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${user!.firstname} ${user!.lastname}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user!.username,
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            buildCompactButton(
                                icon: Icons.edit,
                                label: 'Редактировать',
                                color: Colors.blue,
                                onPressed: _showEditProfileDialog),
                            buildCompactButton(
                                icon: Icons.lock,
                                label: 'Изменить Пароль',
                                color: Colors.orange,
                                onPressed: _showChangePasswordDialog),
                            buildCompactButton(
                                icon: Icons.shopping_cart,
                                label: 'Заказы',
                                color: Colors.green,
                                onPressed: () => widget.onMenuTap(7)),
                            buildCompactButton(
                                icon: Icons.logout,
                                label: 'Выйти',
                                color: Colors.red,
                                onPressed: logout),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
