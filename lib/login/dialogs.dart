// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service.dart';

void showNewUser(
    BuildContext context,
    TextEditingController newUserController,
    TextEditingController newPassController,
    TextEditingController newEmailController,
    TextEditingController dropdownController) {
  final localContext = context;
  const List<String> list = <String>['D.A.C', 'D.A.C 2', 'D.A.C 3', 'D.A.C 4'];
  String dropdownValue = list.first;
  bool isPasswordVisible = false;
  showDialog(
    context: localContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Novo Utilizador'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: newUserController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          labelText: "Utilizador",
                          prefixIcon: Opacity(
                            opacity: 0,
                            child: Icon(Icons.person),
                          ),
                          prefixIconConstraints: BoxConstraints(maxWidth: 10),
                          suffixIcon: Icon(
                            Icons.person_outline,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: newPassController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          labelText: "Senha",
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  isPasswordVisible = !isPasswordVisible;
                                },
                              );
                            },
                          ),
                          prefixIcon: const Opacity(
                            opacity: 0,
                            child: Icon(Icons.person),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(maxWidth: 10),
                        ),
                        obscureText: !isPasswordVisible,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: newEmailController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          labelText: "Email",
                          suffixIcon: Icon(Icons.email),
                          prefixIcon: Opacity(
                            opacity: 0,
                            child: Icon(Icons.person),
                          ),
                          prefixIconConstraints: BoxConstraints(maxWidth: 10),
                        ),
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          labelText: "Escolha um Departamento",
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            onChanged: (String? value) {
                              print(value);
                              setState(() {
                                dropdownValue = value!;
                                dropdownController.text = dropdownValue;
                                print(dropdownValue);
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              newUserController.clear();
              newPassController.clear();
              newEmailController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Salvar'),
            onPressed: () async {
              if (newUserController.text.isNotEmpty &&
                  newPassController.text.isNotEmpty &&
                  newEmailController.text.isNotEmpty) {
                ApiService apiService = ApiService();
                var response = await apiService.registerUser(
                  newUserController.text,
                  newEmailController.text,
                  newPassController.text,
                  dropdownValue,
                );
                if (response['success']) {
                  // Sucesso
                  Navigator.of(context).pop();
                  newUserController.clear();
                  newPassController.clear();
                  newEmailController.clear();
                  dropdownController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Cadastro Efetuado Com Sucesso!'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  // Falha
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(response['message']),
                    duration: const Duration(seconds: 2),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todos os campos devem ser preenchidos'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          )
        ],
      );
    },
  );
}

void showForget(context) async {
  final localContext = context;
  final TextEditingController forgetEmailController = TextEditingController();

  showDialog(
    context: localContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Esqueceu a Password?'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: forgetEmailController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  labelText: "Email",
                  prefixIcon: Opacity(
                    opacity: 0,
                    child: Icon(Icons.person),
                  ),
                  prefixIconConstraints: BoxConstraints(maxWidth: 10),
                  suffixIcon: Icon(Icons.person_outlined),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              forgetEmailController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Redefinir Password'),
            onPressed: () async {
              var response = await ApiService()
                  .recoverPassword(forgetEmailController.text);
              if (response['success']) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response['message']),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop(); // Fecha o diálogo atual
                showResetPasswordDialog(context, forgetEmailController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response['message']),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
              forgetEmailController.clear();
            },
          )
        ],
      );
    },
  );
}

void showResetPasswordDialog(BuildContext context, String userEmail) {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final localContext = context;
  bool isPasswordVisible = false;
  bool isPasswordVisibleC = false;

  showDialog(
    context: localContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Redefinir Password'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            isPasswordVisible = !isPasswordVisible;
                          },
                        );
                      },
                    ),
                    prefixIcon: const Opacity(
                      opacity: 0,
                      child: Icon(Icons.person),
                    ),
                    prefixIconConstraints: const BoxConstraints(maxWidth: 10),
                  ),
                  obscureText: !isPasswordVisible,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmNewPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    labelText: 'Confirmar Nova Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisibleC
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            isPasswordVisibleC = !isPasswordVisibleC;
                          },
                        );
                      },
                    ),
                    prefixIcon: const Opacity(
                      opacity: 0,
                      child: Icon(Icons.person),
                    ),
                    prefixIconConstraints: const BoxConstraints(maxWidth: 10),
                  ),
                  obscureText: !isPasswordVisibleC,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Salvar'),
            // Dentro do TextButton 'Salvar'
            onPressed: () async {
              if (newPasswordController.text ==
                  confirmNewPasswordController.text) {
                var response = await ApiService().updatePassword(userEmail,
                    newPasswordController.text); // Use userEmail aqui
                if (response['success']) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(response['message']),
                        duration: const Duration(seconds: 2)),
                  );
                } else {
                  debugPrint('As senhas não coincidem');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(response['message']),
                        duration: const Duration(seconds: 2)),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('As senhas não coincidem'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

void saveUser(String username, String password, String usertype) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setString('password', password);
  await prefs.setString('usertype', usertype);
  ("Usuário salvo: $username, Senha: $password, Tipo: $usertype");
  print("Usuário salvo: $username, Senha: $password, Tipo: $usertype");
}

Future<bool> verifyUser(String username, String password) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String savedUsername = prefs.getString('username') ?? '';
  final String savedPassword = prefs.getString('password') ?? '';
  return username == savedUsername && password == savedPassword;
}
