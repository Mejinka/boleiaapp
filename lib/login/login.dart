// ignore_for_file: use_build_context_synchronously

import 'package:app_boleia/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service.dart';
import 'dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final newUserController = TextEditingController();

  final newPassController = TextEditingController();

  final newEmailController = TextEditingController();

  final dropdownController = TextEditingController();

  final dropdownCartController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
            stops: [0.5, 0.5],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 130.0,
                height: 130.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo2.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: 0.85 * screenWidth,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 255, 0, 0).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 0.7 * screenWidth,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: userController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Utilizador',
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Opacity(
                            opacity: 0,
                            child: Icon(Icons.person),
                          ),
                          prefixIconConstraints: BoxConstraints(maxWidth: 10),
                          suffixIcon: Icon(
                            Icons.person_outlined,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    SizedBox(
                      width: 0.7 * screenWidth,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: passwordController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          prefixIcon: const Opacity(
                            opacity: 0,
                            child: Icon(Icons.person),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(maxWidth: 10),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            showNewUser(
                              context,
                              newUserController,
                              newPassController,
                              newEmailController,
                              dropdownController,
                              dropdownCartController,
                            );
                          },
                          child: const Text(
                            'Novo Utilizador',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showForget(context);
                          },
                          child: const Text(
                            'Esqueceu a Password?',
                            style: TextStyle(color: Colors.black87),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: const MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.red.shade800,
                          ),
                        ),
                        onPressed: () async {
                          String username = userController.text;
                          String password = passwordController.text;
                          if (username.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Utilizador e Password não podem estar vazios'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            var response = await ApiService()
                                .loginUser(username, password);
                            if (response['success']) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  'username', response['usuario']);
                              await prefs.setString(
                                  'usertype', response['departamento']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoadingPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message']),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
