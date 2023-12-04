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
  final TextEditingController forgetUserController = TextEditingController();

  showDialog(
    context: localContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Esqueceu a senha?'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: forgetUserController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  labelText: "Usuário",
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
              forgetUserController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Redefinir Senha'),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final String savedUsername = prefs.getString('username') ?? '';

              if (forgetUserController.text == savedUsername) {
                Navigator.of(context).pop();
                showResetPasswordDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuário incorreto'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
              forgetUserController.clear();
            },
          )
        ],
      );
    },
  );
}

void showResetPasswordDialog(BuildContext context) {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Redefinir Senha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmNewPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Salvar'),
            onPressed: () async {
              if (newPasswordController.text ==
                  confirmNewPasswordController.text) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                String currentUsername = prefs.getString('username') ?? '';
                String currentUserType =
                    prefs.getString('usertype') ?? ''; // Adicionado

                if (currentUsername.isNotEmpty) {
                  saveUser(currentUsername, newPasswordController.text,
                      currentUserType);
                  Navigator.of(dialogContext).pop();
                }
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
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

void savePro(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Procedimento'),
        content: const Text('Deseja Salvar o Procedimento?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Não'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Sim'),
            onPressed: () {
              Navigator.of(context).pop();
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
